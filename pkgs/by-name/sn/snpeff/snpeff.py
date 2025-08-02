#!/usr/bin/env python
#
# Wrapper script for Java Conda packages that ensures that the java runtime
# is invoked with the right options. Adapted from the bash script (http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in/246128#246128).

# from bioconda https://github.com/bioconda/bioconda-recipes/blob/0bd8b377aae43bcef1e41dea47a2e5ca45212782/recipes/snpeff/snpeff.py
#
# Program Parameters
#
import os
import subprocess
import sys
import shutil
from os import access
from os import getenv
from os import X_OK

jar_file = 'snpEff.jar'

# Phone home has been disabled due to usage of an unregistered domain
# If in the future the "phone home" feature becomes "opt-in" (e.g. -Log)
# please remove the below to allow users to opt in
disable_phone_home_opts = ['-noLog']

default_jvm_mem_opts = ['-Xms512m', '-Xmx1g']

# !!! End of parameter section. No user-serviceable code below this line !!!


def real_dirname(path):
    """Return the symlink-resolved, canonicalized directory-portion of path."""
    return os.path.dirname(os.path.realpath(path))


def java_executable():
    """Return the executable name of the Java interpreter."""
    java_home = getenv('JAVA_HOME')
    java_bin = os.path.join('bin', 'java')

    if java_home and access(os.path.join(java_home, java_bin), X_OK):
        return os.path.join(java_home, java_bin)
    else:
        return 'java'


def jvm_opts(argv):
    """Construct list of Java arguments based on our argument list.

    The argument list passed in argv must not include the script name.
    The return value is a 3-tuple lists of strings of the form:
      (memory_options, prop_options, passthrough_options)
    """
    mem_opts = []
    prop_opts = []
    pass_args = []
    exec_dir = None
    is_dryrun = False

    for arg in argv:
        if arg.startswith('-D'):
            prop_opts.append(arg)
        elif arg.startswith('-XX'):
            prop_opts.append(arg)
        elif arg.startswith('-Xm'):
            mem_opts.append(arg)
        elif arg.startswith('--exec_dir='):
            exec_dir = arg.split('=')[1].strip('"').strip("'")
            if not os.path.exists(exec_dir):
                shutil.copytree(real_dirname(sys.argv[0]), exec_dir, symlinks=False, ignore=None)
        elif arg.startswith('--dry-run'):
            is_dryrun = True
        else:
            pass_args.append(arg)

    # In the original shell script the test coded below read:
    #   if [ "$jvm_mem_opts" == "" ] && [ -z ${_JAVA_OPTIONS+x} ]
    # To reproduce the behaviour of the above shell code fragment
    # it is important to explictly check for equality with None
    # in the second condition, so a null envar value counts as True!

    if mem_opts == [] and getenv('_JAVA_OPTIONS') is None:
        mem_opts = default_jvm_mem_opts

    return (mem_opts, prop_opts, pass_args, exec_dir, is_dryrun)


def main():
    java = java_executable()
    """
    PeptideShaker updates files relative to the path of the jar file.
    In a multiuser setting, the option --exec_dir="exec_dir"
    can be used as the location for the peptide-shaker distribution.
    If the exec_dir dies not exist,
    we copy the jar file, lib, and resources to the exec_dir directory.
    """
    (mem_opts, prop_opts, pass_args, exec_dir, is_dryrun) = jvm_opts(sys.argv[1:])
    jar_dir = exec_dir if exec_dir else real_dirname(sys.argv[0])

    if pass_args != [] and pass_args[0].startswith('eu'):
        jar_arg = '-cp'
    else:
        jar_arg = '-jar'

    jar_path = os.path.join(jar_dir, jar_file)

    java_args = [java] + mem_opts + prop_opts + [jar_arg] + [jar_path] + pass_args + disable_phone_home_opts

    if is_dryrun:
        sys.exit(print(java_args))
    else:
        sys.exit(subprocess.call(java_args))


if __name__ == '__main__':
    main()
