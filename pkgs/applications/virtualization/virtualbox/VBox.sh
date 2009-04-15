#!/bin/sh

INSTALL_PATH="@INSTALL_PATH@"
export LD_LIBRARY_PATH="@INSTALL_PATH@:@QT4_PATH@"

export USER=$(whoami)

if [ ! -c /dev/vboxdrv ]; then
  echo "/dev/vboxdrv does not exist. Load the kernel module then try again."
  exit 1
fi
if [ ! -r /dev/vboxdrv -o ! -w /dev/vboxdrv ]; then
  echo "User $USER can not read and/or write to /dev/vboxdrv."
  exit 1
fi

echo "/dev/vboxdrv exists and $USER can access it."

SERVER_PID=$(ps -U $USER | grep VBoxSVC | awk '{ print $1 }')
if [ "$1" = "shutdown" ]; then
  if [ -n "$SERVER_PID" ]; then
    echo "Terminating VBoxSVC with PID $SERVER_PID."
    kill -TERM $SERVER_PID
  else
    echo "VBoxSVC Not Currently Running."
  fi
  exit 0
fi

if [ ! -x "$INSTALL_PATH/VBoxSVC" ]; then
  echo "$INSTALL_PATH/VBoxSVC does not exist! Can not continue."
  exit 1
fi

APP=$(which $0)
APP=${APP##/*/}

if [ ! -x "$INSTALL_PATH/$APP" ]; then
  echo "$INSTALL_PATH/$APP does not exist!"
  exit 1
fi
case "$APP" in
  VirtualBox|VBoxManage|VBoxSDL|VBoxVRDP)
    EXEC_APP="$INSTALL_PATH/$APP"
  ;;
  *)
    echo "Unknown application - $APP."
  ;;
esac

if [ -z "$SERVER_PID" ]; then
  rm -rf /tmp/.vbox-$USER-ipc
  echo "Starting VBoxSVC for $USER."
  "$INSTALL_PATH/VBoxSVC" --daemonize
fi

SERVER_PID=$(ps -U $USER | grep VBoxSVC | awk '{ print $1 }')
if [ -z "$SERVER_PID" ]; then
  echo "VBoxSVC failed to start! Can not continue"
  exit 1
fi

echo "VBoxSVC is running for user $USER with PID $SERVER_PID."

echo "Starting $EXEC_APP."
exec "$EXEC_APP" "$@"
