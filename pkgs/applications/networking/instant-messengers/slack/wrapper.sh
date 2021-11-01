#! @shell@

export XDG_DATA_DIRS=@GSETTINGS_SCHEMAS_PATH@${XDG_DATA_DIRS:+':'}$XDG_DATA_DIRS
export PATH=@xdg_utils@${PATH:+':'}$PATH

if [ "${XDG_SESSION_TYPE}" == "wayland" ]; then
    set -- --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland "$@"
fi

exec @out@/lib/slack/slack "$@"
