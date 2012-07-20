#!/usr/bin/python -t
# this script was written to use /etc/nixos/nixpkgs/pkgs/development/python-modules/generic/wrap.sh
# which already automates python executable wrapping by extending the PATH/pythonPath

# from http://docs.python.org/library/subprocess.html
# Warning Invoking the system shell with shell=True can be a security hazard if combined with untrusted input. See the warning under Frequently Used Arguments for details.

from subprocess import Popen, PIPE, STDOUT

cmd = 'PYTHON_EXECUTABLE_PATH -t THE_CUSTOM_PATH/share/virt-manager/THE_CUSTOM_PROGRAM.py'
p = Popen(cmd, shell=True, stdin=PIPE, stdout=PIPE, stderr=STDOUT, close_fds=True)
output = p.stdout.read()
print output
