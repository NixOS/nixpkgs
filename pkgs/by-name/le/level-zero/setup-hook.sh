if [ -d /run/opengl-driver/lib ]; then
  export LD_LIBRARY_PATH="/run/opengl-driver/lib${LD_LIBRARY_PATH:+:}${LD_LIBRARY_PATH:-}"
fi

if [ -d /run/opengl-driver-32/lib ]; then
  export LD_LIBRARY_PATH="/run/opengl-driver-32/lib${LD_LIBRARY_PATH:+:}${LD_LIBRARY_PATH:-}"
fi
