# /etc/profile: DO NOT EDIT -- this file has been generated automatically.

# This file is read for (interactive) login shells.  Any
# initialisation specific to interactive shells should be put in
# /etc/bashrc, which is sourced from here.

# Only execute this file once per shell.
if [ -n "$__ETC_PROFILE_SOURCED" ]; then return; fi
__ETC_PROFILE_SOURCED=1

# Prevent this file from being sourced by interactive non-login child shells.
export __ETC_PROFILE_DONE=1

# Initialise a bunch of environment variables.
export LOCALE_ARCHIVE=/run/current-system/sw/lib/locale/locale-archive
export LD_LIBRARY_PATH=/run/nss:/run/opengl-driver/lib:/run/opengl-driver-32/lib # !!! only set if needed
export NIXPKGS_CONFIG=/etc/nix/nixpkgs-config.nix
export NIX_PATH=/nix/var/nix/profiles/per-user/root/channels/nixos:nixpkgs=/etc/nixos/nixpkgs:nixos=/etc/nixos/nixos:nixos-config=/etc/nixos/configuration.nix:services=/etc/nixos/services
export PAGER="less -R"
export EDITOR=nano
export LOCATE_PATH=/var/cache/locatedb

# Include the various profiles in the appropriate environment variables.
export NIX_USER_PROFILE_DIR=/nix/var/nix/profiles/per-user/$USER
export NIX_PROFILES="/run/current-system/sw /nix/var/nix/profiles/default $HOME/.nix-profile"

unset PATH INFOPATH PKG_CONFIG_PATH PERL5LIB ALSA_PLUGIN_DIRS GST_PLUGIN_PATH KDEDIRS
unset QT_PLUGIN_PATH QTWEBKIT_PLUGIN_PATH STRIGI_PLUGIN_PATH XDG_CONFIG_DIRS XDG_DATA_DIRS
unset MOZ_PLUGIN_PATH TERMINFO_DIRS

for i in $NIX_PROFILES; do # !!! reverse
    # We have to care not leaving an empty PATH element, because that means '.' to Linux
    export PATH=$i/bin:$i/sbin:$i/lib/kde4/libexec${PATH:+:}$PATH
    export INFOPATH=$i/info:$i/share/info${INFOPATH:+:}$INFOPATH
    export PKG_CONFIG_PATH="$i/lib/pkgconfig${PKG_CONFIG_PATH:+:}$PKG_CONFIG_PATH"

    # terminfo and reset TERM with new TERMINFO available
    export TERMINFO_DIRS=$i/share/terminfo${TERMINFO_DIRS:+:}$TERMINFO_DIRS
    export TERM=$TERM

    export PERL5LIB="$i/lib/perl5/site_perl${PERL5LIB:+:}$PERL5LIB"

    # ALSA plugins
    export ALSA_PLUGIN_DIRS="$i/lib/alsa-lib${ALSA_PLUGIN_DIRS:+:}$ALSA_PLUGIN_DIRS"

    # GStreamer.
    export GST_PLUGIN_PATH="$i/lib/gstreamer-0.10${GST_PLUGIN_PATH:+:}$GST_PLUGIN_PATH"

    # KDE/Gnome stuff.
    export KDEDIRS=$i${KDEDIRS:+:}$KDEDIRS
    export STRIGI_PLUGIN_PATH=$i/lib/strigi/${STRIGI_PLUGIN_PATH:+:}$STRIGI_PLUGIN_PATH
    export QT_PLUGIN_PATH=$i/lib/qt4/plugins:$i/lib/kde4/plugins${QT_PLUGIN_PATH:+:}:$QT_PLUGIN_PATH
    export QTWEBKIT_PLUGIN_PATH=$i/lib/mozilla/plugins/${QTWEBKIT_PLUGIN_PATH:+:}$QTWEBKIT_PLUGIN_PATH
    export XDG_CONFIG_DIRS=$i/etc/xdg${XDG_CONFIG_DIRS:+:}$XDG_CONFIG_DIRS
    export XDG_DATA_DIRS=$i/share${XDG_DATA_DIRS:+:}$XDG_DATA_DIRS

    # Mozilla plugins.
    export MOZ_PLUGIN_PATH=$i/lib/mozilla/plugins${MOZ_PLUGIN_PATH:+:}$MOZ_PLUGIN_PATH
done

# Search directory for Aspell dictionaries.
export ASPELL_CONF="dict-dir $HOME/.nix-profile/lib/aspell"

# The setuid wrappers override other bin directories.
export PATH=@wrapperDir@:$PATH

# ~/bin if it exists overrides other bin directories.
if [ -d $HOME/bin ]; then
    export PATH=$HOME/bin:$PATH
fi

# Set up the per-user profile.
mkdir -m 0755 -p $NIX_USER_PROFILE_DIR
if test "$(stat --printf '%u' $NIX_USER_PROFILE_DIR)" != "$(id -u)"; then
    echo "WARNING: bad ownership on $NIX_USER_PROFILE_DIR" >&2
fi

if ! test -L $HOME/.nix-profile; then
    echo "creating $HOME/.nix-profile" >&2
    if test "$USER" != root; then
        ln -s $NIX_USER_PROFILE_DIR/profile $HOME/.nix-profile
    else
        # Root installs in the system-wide profile by default.
        ln -s /nix/var/nix/profiles/default $HOME/.nix-profile
    fi
fi

# Subscribe the root user to the NixOS channel by default.
if [ "$USER" = root -a ! -e $HOME/.nix-channels ]; then
    echo "http://nixos.org/channels/nixos-unstable nixos" > $HOME/.nix-channels
fi

# Create the per-user garbage collector roots directory.
NIX_USER_GCROOTS_DIR=/nix/var/nix/gcroots/per-user/$USER
mkdir -m 0755 -p $NIX_USER_GCROOTS_DIR
if test "$(stat --printf '%u' $NIX_USER_GCROOTS_DIR)" != "$(id -u)"; then
    echo "WARNING: bad ownership on $NIX_USER_GCROOTS_DIR" >&2
fi

# Set up a default Nix expression from which to install stuff.
if [ ! -e $HOME/.nix-defexpr -o -L $HOME/.nix-defexpr ]; then
    echo "creating $HOME/.nix-defexpr" >&2
    rm -f $HOME/.nix-defexpr
    mkdir $HOME/.nix-defexpr
    if [ "$USER" != root ]; then
        ln -s /nix/var/nix/profiles/per-user/root/channels $HOME/.nix-defexpr/channels_root
    fi
fi

@shellInit@

# Read system-wide modifications.
if test -f /etc/profile.local; then
    . /etc/profile.local
fi

if [ -n "${BASH_VERSION:-}" ]; then
    . /etc/bashrc
fi
