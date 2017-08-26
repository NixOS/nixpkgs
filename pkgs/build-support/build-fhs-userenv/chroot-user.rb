#!/usr/bin/env ruby

# Bind mounts hierarchy: from => to (relative)
# If 'to' is nil, path will be the same
mounts = { '/' => 'host',
           '/proc' => nil,
           '/sys' => nil,
           '/nix' => nil,
           '/tmp' => nil,
           '/var' => nil,
           '/run' => nil,
           '/dev' => nil,
           '/home' => nil,
         }

# Propagate environment variables
envvars = [ 'TERM',
            'DISPLAY',
            'XAUTHORITY',
            'HOME',
            'XDG_RUNTIME_DIR',
            'LANG',
            'SSL_CERT_FILE',
            'DBUS_SESSION_BUS_ADDRESS',
          ]

require 'tmpdir'
require 'fileutils'
require 'pathname'
require 'set'
require 'fiddle'

def write_file(path, str)
  File.open(path, 'w') { |file| file.write str }
end

# Import C standard library and several needed calls
$libc = Fiddle.dlopen nil

def make_fcall(name, args, output)
  c = Fiddle::Function.new $libc[name], args, output
  lambda do |*args|
    ret = c.call *args
    raise SystemCallError.new Fiddle.last_error if ret < 0
    return ret
  end
end

$fork = make_fcall 'fork', [], Fiddle::TYPE_INT

CLONE_NEWNS   = 0x00020000
CLONE_NEWUSER = 0x10000000
$unshare = make_fcall 'unshare', [Fiddle::TYPE_INT], Fiddle::TYPE_INT

MS_BIND = 0x1000
MS_REC  = 0x4000
MS_SLAVE  = 0x80000
$mount = make_fcall 'mount', [Fiddle::TYPE_VOIDP,
                              Fiddle::TYPE_VOIDP,
                              Fiddle::TYPE_VOIDP,
                              Fiddle::TYPE_LONG,
                              Fiddle::TYPE_VOIDP],
                    Fiddle::TYPE_INT

# Read command line args
abort "Usage: chrootenv program args..." unless ARGV.length >= 1
execp = ARGV

# Populate extra mounts
if not ENV["CHROOTENV_EXTRA_BINDS"].nil?
  $stderr.puts "CHROOTENV_EXTRA_BINDS is discussed for deprecation."
  $stderr.puts "If you have a usecase, please drop a note in issue #16030."
  $stderr.puts "Notice that we now bind-mount host FS to '/host' and symlink all directories from it to '/' by default."

  for extra in ENV["CHROOTENV_EXTRA_BINDS"].split(':')
    paths = extra.split('=')
    if not paths.empty?
      if paths.size <= 2
        mounts[paths[0]] = paths[1]
      else
        $stderr.puts "Ignoring invalid entry in CHROOTENV_EXTRA_BINDS: #{extra}"
      end
    end
  end
end

# Set destination paths for mounts
mounts = mounts.map { |k, v| [k, v.nil? ? k.sub(/^\/*/, '') : v] }.to_h

# Create temporary directory for root and chdir
root = Dir.mktmpdir 'chrootenv'

# Fork process; we need this to do a proper cleanup because
# child process will chroot into temporary directory.
# We use imported 'fork' instead of native to overcome
# CRuby's meddling with threads; this should be safe because
# we don't use threads at all.
$cpid = $fork.call
if $cpid == 0
  # If we are root, no need to create new user namespace.
  if Process.uid == 0
    $unshare.call CLONE_NEWNS
    # Mark all mounted filesystems as slave so changes
    # don't propagate to the parent mount namespace.
    $mount.call nil, '/', nil, MS_REC | MS_SLAVE, nil
  else
    # Save user UID and GID
    uid = Process.uid
    gid = Process.gid

    # Create new mount and user namespaces
    # CLONE_NEWUSER requires a program to be non-threaded, hence
    # native fork above.
    $unshare.call CLONE_NEWNS | CLONE_NEWUSER

    # Map users and groups to the parent namespace
    begin
      # setgroups is only available since Linux 3.19
      write_file '/proc/self/setgroups', 'deny'
    rescue
    end
    write_file '/proc/self/uid_map', "#{uid} #{uid} 1"
    write_file '/proc/self/gid_map', "#{gid} #{gid} 1"
  end

  # Do rbind mounts.
  mounts.each do |from, rto|
    to = "#{root}/#{rto}"
    FileUtils.mkdir_p to
    $mount.call from, to, nil, MS_BIND | MS_REC, nil
  end

  # Don't make root private so privilege drops inside chroot are possible
  File.chmod(0755, root)
  # Chroot!
  Dir.chroot root
  Dir.chdir '/'

  # New environment
  new_env = Hash[ envvars.map { |x| [x, ENV[x]] } ]

  # Finally, exec!
  exec(new_env, *execp, close_others: true, unsetenv_others: true)
end

# Wait for a child. If we catch a signal, resend it to child and continue
# waiting.
def wait_child
  begin
    Process.wait

    # Return child's exit code
    if $?.exited?
      exit $?.exitstatus
      else
      exit 1
    end
  rescue SignalException => e
    Process.kill e.signo, $cpid
    wait_child
  end
end

begin
  wait_child
ensure
  # Cleanup
  FileUtils.rm_rf root, secure: true
end
