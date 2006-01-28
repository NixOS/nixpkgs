profileName=opengl
profileDir=/nix/var/nix/profiles
profile=$profileDir/$profileName

if test -z "$OPENGL_DRIVER"; then
    if test -d "$profile/lib"; then
        OPENGL_DRIVER=$profile
    fi
fi

if test -z "$OPENGL_DRIVER"; then

    cat <<EOF
======================================================================
This program uses OpenGL for 3D graphics.  For best performance, you
should use a hardware-accelerated implementation of OpenGL.  Since you
have not enabled one, a software implementation (Mesa) will be used.
This will probably be quite slow.

This program will look for a hardware-accelerated implementation of
OpenGL in the "$profileName" profile of your Nix installation.  For
instance, to enable the (hopefully) accelerated driver provided by
your (non-NixOS) Linux distribution, try

  $ nix-env -p $profile -i xorg-sys-opengl

Alternatively, you can set the OPENGL_DRIVER environment variable to
point at the package containing the OpenGL implementation.
======================================================================

EOF

    OPENGL_DRIVER=$mesa
fi

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH${LD_LIBRARY_PATH:+:}$OPENGL_DRIVER/lib

hook="$OPENGL_DRIVER/nix-support/opengl-hook"
if test -e "$hook"; then
    source "$hook"
fi
