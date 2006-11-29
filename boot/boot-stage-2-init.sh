#! @shell@

# !!! copied from stage 1; remove duplication


# Print a greeting.
echo
echo "<<< NixOS Stage 2 >>>"
echo


# Set the PATH.
export PATH=/empty
for i in @startPath@; do
    PATH=$PATH:$i/bin
    if test -e $i/sbin; then
        PATH=$PATH:$i/sbin
    fi
done


# Mount special file systems.

needWritableDir() {
    if test -n "@readOnlyRoot@"; then
        mount -t tmpfs -o "mode=$2" none $1 $3
    else
        mkdir -m $2 -p $1
    fi
}

needWritableDir /etc 0755 -n # to shut up mount

test -e /etc/fstab || touch /etc/fstab # idem

mount -n -t proc none /proc
cat /proc/mounts > /etc/mtab


# Process the kernel command line.
for o in $(cat /proc/cmdline); do
    case $o in
        debugtrace)
            # Show each command.
            set -x
            ;;
        debug2)
            echo "Debug shell called from @out@"
            exec @shell@
            ;;
        S|s|single)
            # !!! argh, can't pass a startup event to Upstart yet.
            exec @shell@
            ;;
    esac
done


# More special file systems, initialise required directories.
mount -t sysfs none /sys
mount -t tmpfs -o "mode=0755" none /dev
needWritableDir /tmp 01777
needWritableDir /var 0755
needWritableDir /nix/var 0755

mkdir -m 0755 -p /nix/var/nix/db
mkdir -m 0755 -p /nix/var/nix/gcroots
mkdir -m 0755 -p /nix/var/nix/temproots

mkdir -m 0755 -p /var/log

ln -sf /nix/var/nix/profiles /nix/var/nix/gcroots/


# Ensure that the module tools can find the kernel modules.
export MODULE_DIR=@kernel@/lib/modules/


# Miscellaneous cleanup.
rm -rf /var/run
mkdir -m 0755 -p /var/run

echo -n > /var/run/utmp # must exist
chmod 664 /var/run/utmp


# Start udev.
udevd --daemon


# Let udev create device nodes for all modules that have already been
# loaded into the kernel (or for which support is built into the
# kernel).
udevtrigger
udevsettle # wait for udev to finish


# Necessary configuration for syslogd.
echo "*.* /dev/tty10" > /etc/syslog.conf
echo "syslog 514/udp" > /etc/services # required, even if we don't use it


# login/su absolutely need this.
test -e /etc/login.defs || touch /etc/login.defs 


# Enable a password-less root login.
source @accounts@

if ! test -e /etc/passwd; then
    if test -n "@readOnlyRoot@"; then
        rootHome=/
    else
        rootHome=/home/root
        mkdir -p $rootHome
    fi
    createUser root '' 0 0 'System administrator' $rootHome/var/empty @shell@
fi

if ! test -e /etc/group; then
    echo "root:*:0" > /etc/group
fi


# We need "localhost" (!!! destructive hack for NIXOS-41).
echo "127.0.0.1 localhost" > /etc/hosts
echo "hosts: files dns" > /etc/nsswitch.conf


# Set up Nix accounts.
if test -z "@readOnlyRoot@"; then

    for i in $(seq 1 10); do
        account=nix-build-$i
        if ! userExists $account; then
            createUser $account x \
                $((i + 30000)) $((i + 30000)) \
                'Nix build user' /var/empty /noshell
        fi
        accounts="$accounts $account"
    done

    mkdir -p /nix/etc/nix
    cat > /nix/etc/nix/nix.conf <<EOF
build-allow-root = false
build-users = $accounts
EOF

fi


# Set up the Upstart jobs.
export UPSTART_CFG_DIR=/etc/event.d

rm -f /etc/event.d
ln -sf @upstartJobs@/etc/event.d /etc/event.d


# Show a nice greeting on each terminal.
cat > /etc/issue <<EOF

<<< Welcome to NixOS (\m) - Kernel \r (\l) >>>


EOF


# Additional path for the interactive shell.
PATH=@wrapperDir@:@fullPath@/bin:@fullPath@/sbin

cat > /etc/profile <<EOF
export PATH=$PATH
export MODULE_DIR=$MODULE_DIR
export NIX_CONF_DIR=/nix/etc/nix

source $(dirname $(readlink -f $(type -tp nix-env)))/../etc/profile.d/nix.sh

alias ll="ls -l"

if test -f /etc/profile.local; then
    source /etc/profile.local
fi
EOF


# Make a few setuid programs work.
wrapperDir=@wrapperDir@
if test -d $wrapperDir; then rm -f $wrapperDir/*; fi
mkdir -p $wrapperDir
for i in passwd su; do
    program=$(type -tp $i)
    cp $(type -tp setuid-wrapper) $wrapperDir/$i
    echo -n $program > $wrapperDir/$i.real
    chown root.root $wrapperDir/$i
    chmod 4755 $wrapperDir/$i
done


# Set the host name.
hostname @hostName@


# Start an interactive shell.
#exec @shell@


# Start Upstart's init.
exec @upstart@/sbin/init -v
