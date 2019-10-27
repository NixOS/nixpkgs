#! @shell@ -e

# The following lines create/update the HylaFAX spool directory:
# Subdirectories/files with persistent data are kept,
# other directories/files are removed/recreated,
# mostly from the template spool
# directory in the HylaFAX package.

# This block explains how the spool area is
# derived from the spool template in the HylaFAX package:
#
#                  + capital letter: directory; file otherwise
#                  + P/p: persistent directory
#                  + F/f: directory with symlinks per entry
#                  + T/t: temporary data
#                  + S/s: single symlink into package
#                  |
#                  | + u: change ownership to uucp:uucp
#                  | + U: ..also change access mode to user-only
#                  | |
# archive          P U
# bin              S
# client           T u  (client connection info)
# config           S
# COPYRIGHT        s
# dev              T u  (maybe some FIFOs)
# docq             P U
# doneq            P U
# etc              F    contains customized config files!
# etc/hosts.hfaxd  f
# etc/xferfaxlog   f
# info             P u  (database of called devices)
# log              P u  (communication logs)
# pollq            P U
# recvq            P u
# sendq            P U
# status           T u  (modem status info files)
# tmp              T U


shopt -s dotglob  # if bash sees "*", it also includes dot files
lnsym () { ln --symbol "$@" ; }
lnsymfrc () { ln --symbolic --force "$@" ; }
cprd () { cp --remove-destination "$@" ; }
update () { install --owner=@faxuser@ --group=@faxgroup@ "$@" ; }


## create/update spooling area

update --mode=0750 -d "@spoolAreaPath@"
cd "@spoolAreaPath@"

persist=(archive docq doneq info log pollq recvq sendq)

# remove entries that don't belong here
touch dummy  # ensure "*" resolves to something
for k in *
do
  keep=0
  for j in "${persist[@]}" xferfaxlog clientlog faxcron.lastrun
  do
    if test "$k" == "$j"
    then
      keep=1
      break
    fi
  done
  if test "$keep" == "0"
  then
    rm --recursive "$k"
  fi
done

# create persistent data directories (unless they exist already)
update --mode=0700 -d "${persist[@]}"
chmod 0755 info log recvq

# create ``xferfaxlog``, ``faxcron.lastrun``, ``clientlog``
touch clientlog faxcron.lastrun xferfaxlog
chown @faxuser@:@faxgroup@ clientlog faxcron.lastrun xferfaxlog

# create symlinks for frozen directories/files
lnsym --target-directory=. "@hylafax@"/spool/{COPYRIGHT,bin,config}

# create empty temporary directories
update --mode=0700 -d client dev status
update -d tmp


## create and fill etc

install -d "@spoolAreaPath@/etc"
cd "@spoolAreaPath@/etc"

# create symlinks to all files in template's etc
lnsym --target-directory=. "@hylafax@/spool/etc"/*

# set LOCKDIR in setup.cache
sed --regexp-extended 's|^(UUCP_LOCKDIR=).*$|\1'"'@lockPath@'|g" --in-place setup.cache

# etc/{xferfaxlog,lastrun} are stored in the spool root
lnsymfrc --target-directory=. ../xferfaxlog
lnsymfrc --no-target-directory ../faxcron.lastrun lastrun

# etc/hosts.hfaxd is provided by the NixOS configuration
lnsymfrc --no-target-directory "@userAccessFile@" hosts.hfaxd

# etc/config and etc/config.${DEVID} must be copied:
# hfaxd reads these file after locking itself up in a chroot
cprd --no-target-directory "@globalConfigPath@" config
cprd --target-directory=. "@modemConfigPath@"/*
