#!@shell@

###########################################################################
# /usr/bin/service
#
# A convenient wrapper for the /etc/init.d init scripts.
#
# This script is a modified version of the /sbin/service utility found on
# Red Hat/Fedora systems (licensed GPLv2+).
#
# Copyright (C) 2006 Red Hat, Inc. All rights reserved.
# Copyright (C) 2008 Canonical Ltd.
#   * August 2008 - Dustin Kirkland <kirkland@canonical.com>
# Copyright (C) 2013 Michael Stapelberg <stapelberg@debian.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# On Debian GNU/Linux systems, the complete text of the GNU General
# Public License can be found in `/usr/share/common-licenses/GPL-2'.
###########################################################################


is_ignored_file() {
    case "$1" in
        skeleton | README | *.dpkg-dist | *.dpkg-old | rc | rcS | single | reboot | bootclean.sh)
            return 0
        ;;
    esac
    return 1
}

VERSION=$(@coreutils@/bin/basename $0)" ver. 19-04"
USAGE="Usage: "$(@coreutils@/bin/basename $0)" < option > | --status-all | \
[ service_name [ command | --full-restart ] ]"
SERVICE=
ACTION=
SERVICEDIR="/etc/init.d"
OPTIONS=
is_systemd=


if [ $# -eq 0 ]; then
   echo "${USAGE}" >&2
   exit 1
fi

if [ -d /run/systemd/system ]; then
   is_systemd=1
fi

cd /
while [ $# -gt 0 ]; do
  case "${1}" in
    --help | -h | --h* )
       echo "${USAGE}" >&2
       exit 0
       ;;
    --version | -V )
       echo "${VERSION}" >&2
       exit 0
       ;;
    *)
       if [ -z "${SERVICE}" -a $# -eq 1 -a "${1}" = "--status-all" ]; then
          if [ -d "${SERVICEDIR}" ]; then
             cd ${SERVICEDIR}
         for SERVICE in * ; do
           case "${SERVICE}" in
             functions | halt | killall | single| linuxconf| kudzu)
                 ;;
             *)
               if ! is_ignored_file "${SERVICE}" \
               && [ -x "${SERVICEDIR}/${SERVICE}" ]; then
                       out=$(env -i LANG="$LANG" LANGUAGE="$LANGUAGE" LC_CTYPE="$LC_CTYPE" LC_NUMERIC="$LC_NUMERIC" LC_TIME="$LC_TIME" LC_COLLATE="$LC_COLLATE" LC_MONETARY="$LC_MONETARY" LC_MESSAGES="$LC_MESSAGES" LC_PAPER="$LC_PAPER" LC_NAME="$LC_NAME" LC_ADDRESS="$LC_ADDRESS" LC_TELEPHONE="$LC_TELEPHONE" LC_MEASUREMENT="$LC_MEASUREMENT" LC_IDENTIFICATION="$LC_IDENTIFICATION" LC_ALL="$LC_ALL" PATH="$PATH" TERM="$TERM" "$SERVICEDIR/$SERVICE" status 2>&1)
                       retval=$?
                       if echo "$out" | egrep -iq "usage:"; then
                         #printf " %s %-60s %s\n" "[?]" "$SERVICE:" "unknown" 1>&2
                         echo " [ ? ]  $SERVICE" 1>&2
                         continue
                       else
                         if [ "$retval" = "0" -a -n "$out" ]; then
                           #printf " %s %-60s %s\n" "[+]" "$SERVICE:" "running"
                           echo " [ + ]  $SERVICE"
                           continue
                         else
                           #printf " %s %-60s %s\n" "[-]" "$SERVICE:" "NOT running"
                           echo " [ - ]  $SERVICE"
                           continue
                         fi
                       fi
                 #env -i LANG="$LANG" LANGUAGE="$LANGUAGE" LC_CTYPE="$LC_CTYPE" LC_NUMERIC="$LC_NUMERIC" LC_TIME="$LC_TIME" LC_COLLATE="$LC_COLLATE" LC_MONETARY="$LC_MONETARY" LC_MESSAGES="$LC_MESSAGES" LC_PAPER="$LC_PAPER" LC_NAME="$LC_NAME" LC_ADDRESS="$LC_ADDRESS" LC_TELEPHONE="$LC_TELEPHONE" LC_MEASUREMENT="$LC_MEASUREMENT" LC_IDENTIFICATION="$LC_IDENTIFICATION" LC_ALL="$LC_ALL" PATH="$PATH" TERM="$TERM" "$SERVICEDIR/$SERVICE" status
               fi
               ;;
           esac
         done
          else
             systemctl $sctl_args list-units
          fi
          exit 0
       elif [ $# -eq 2 -a "${2}" = "--full-restart" ]; then
          SERVICE="${1}"
          # On systems using systemd, we just perform a normal restart:
          # A restart with systemd is already a full restart.
          if [ -n "$is_systemd" ]; then
             ACTION="restart"
          else
             if [ -x "${SERVICEDIR}/${SERVICE}" ]; then
               env -i LANG="$LANG" LANGUAGE="$LANGUAGE" LC_CTYPE="$LC_CTYPE" LC_NUMERIC="$LC_NUMERIC" LC_TIME="$LC_TIME" LC_COLLATE="$LC_COLLATE" LC_MONETARY="$LC_MONETARY" LC_MESSAGES="$LC_MESSAGES" LC_PAPER="$LC_PAPER" LC_NAME="$LC_NAME" LC_ADDRESS="$LC_ADDRESS" LC_TELEPHONE="$LC_TELEPHONE" LC_MEASUREMENT="$LC_MEASUREMENT" LC_IDENTIFICATION="$LC_IDENTIFICATION" LC_ALL="$LC_ALL" PATH="$PATH" TERM="$TERM" "$SERVICEDIR/$SERVICE" stop
               env -i LANG="$LANG" LANGUAGE="$LANGUAGE" LC_CTYPE="$LC_CTYPE" LC_NUMERIC="$LC_NUMERIC" LC_TIME="$LC_TIME" LC_COLLATE="$LC_COLLATE" LC_MONETARY="$LC_MONETARY" LC_MESSAGES="$LC_MESSAGES" LC_PAPER="$LC_PAPER" LC_NAME="$LC_NAME" LC_ADDRESS="$LC_ADDRESS" LC_TELEPHONE="$LC_TELEPHONE" LC_MEASUREMENT="$LC_MEASUREMENT" LC_IDENTIFICATION="$LC_IDENTIFICATION" LC_ALL="$LC_ALL" PATH="$PATH" TERM="$TERM" "$SERVICEDIR/$SERVICE" start
               exit $?
             fi
          fi
       elif [ -z "${SERVICE}" ]; then
         SERVICE="${1}"
       elif [ -z "${ACTION}" ]; then
         ACTION="${1}"
       else
         OPTIONS="${OPTIONS} ${1}"
       fi
       shift
       ;;
   esac
done

run_via_sysvinit() {
   # Otherwise, use the traditional sysvinit
   if [ -x "${SERVICEDIR}/${SERVICE}" ]; then
      exec env -i LANG="$LANG" LANGUAGE="$LANGUAGE" LC_CTYPE="$LC_CTYPE" LC_NUMERIC="$LC_NUMERIC" LC_TIME="$LC_TIME" LC_COLLATE="$LC_COLLATE" LC_MONETARY="$LC_MONETARY" LC_MESSAGES="$LC_MESSAGES" LC_PAPER="$LC_PAPER" LC_NAME="$LC_NAME" LC_ADDRESS="$LC_ADDRESS" LC_TELEPHONE="$LC_TELEPHONE" LC_MEASUREMENT="$LC_MEASUREMENT" LC_IDENTIFICATION="$LC_IDENTIFICATION" LC_ALL="$LC_ALL" PATH="$PATH" TERM="$TERM" "$SERVICEDIR/$SERVICE" ${ACTION} ${OPTIONS}
   else
      echo "${SERVICE}: unrecognized service" >&2
      exit 1
   fi
}

update_openrc_started_symlinks() {
   # maintain the symlinks of /run/openrc/started so that
   # rc-status works with the service command as well
   if [ -d /run/openrc/started ] ; then
      case "${ACTION}" in
      start)
         if [ ! -h /run/openrc/started/$SERVICE ] ; then
            ln -s $SERVICEDIR/$SERVICE /run/openrc/started/$SERVICE || true
         fi
      ;;
      stop)
         rm /run/openrc/started/$SERVICE || true
      ;;
      esac
   fi
}

# When this machine is running systemd, standard service calls are turned into
# systemctl calls.
if [ -n "$is_systemd" ]
then
   UNIT="${SERVICE%.sh}.service"
   # avoid deadlocks during bootup and shutdown from units/hooks
   # which call "invoke-rc.d service reload" and similar, since
   # the synchronous wait plus systemd's normal behaviour of
   # transactionally processing all dependencies first easily
   # causes dependency loops
   if ! systemctl --quiet is-active multi-user.target; then
       sctl_args="--job-mode=ignore-dependencies"
   fi

   case "${ACTION}" in
      restart|status|try-restart)
         exec systemctl $sctl_args ${ACTION} ${UNIT}
      ;;
      start|stop)
         # Follow the principle of least surprise for SysV people:
         # When running "service foo stop" and foo happens to be a service that
         # has one or more .socket files, we also stop the .socket units.
         # Users who need more control will use systemctl directly.
         for unit in $(systemctl list-unit-files --full --type=socket 2>/dev/null | sed -ne 's/\.socket\s*[a-z]*\s*$/.socket/p'); do
             if [ "$(systemctl -p Triggers show $unit)" = "Triggers=${UNIT}" ]; then
                systemctl $sctl_args ${ACTION} $unit
             fi
         done
         exec systemctl $sctl_args ${ACTION} ${UNIT}
      ;;
      reload)
         _canreload="$(systemctl -p CanReload show ${UNIT} 2>/dev/null)"
         if [ "$_canreload" = "CanReload=no" ]; then
            # The reload action falls back to the sysv init script just in case
            # the systemd service file does not (yet) support reload for a
            # specific service.
            run_via_sysvinit
         else
            exec systemctl $sctl_args reload "${UNIT}"
         fi
         ;;
      force-stop)
         exec systemctl --signal=KILL kill "${UNIT}"
         ;;
      force-reload)
         _canreload="$(systemctl -p CanReload show ${UNIT} 2>/dev/null)"
         if [ "$_canreload" = "CanReload=no" ]; then
            exec systemctl $sctl_args restart "${UNIT}"
         else
            exec systemctl $sctl_args reload "${UNIT}"
         fi
         ;;
      *)
         # We try to run non-standard actions by running
         # the init script directly.
         run_via_sysvinit
         ;;
   esac
fi

update_openrc_started_symlinks
run_via_sysvinit
