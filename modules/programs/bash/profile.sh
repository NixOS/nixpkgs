# /etc/profile: DO NOT EDIT -- this file has been generated automatically.

if [ -n "${SYSTEM_ETC_PROFILE_HAS_BEEN_SOURCED:-}" ]; then
    return
else
    SYSTEM_ETC_PROFILE_HAS_BEEN_SOURCED="1"
fi

# Initialise a bunch of environment variables.
export LD_LIBRARY_PATH=/var/run/opengl-driver/lib:/var/run/opengl-driver-32/lib # !!! only set if needed
export MODULE_DIR=@modulesTree@/lib/modules
export NIXPKGS_CONFIG=/nix/etc/config.nix
export NIXPKGS_ALL=/etc/nixos/nixpkgs
export NIX_PATH=nixpkgs=/etc/nixos/nixpkgs:nixos=/etc/nixos/nixos:nixos-config=/etc/nixos/configuration.nix:services=/etc/nixos/services
export PAGER="less -R"
export EDITOR=nano
export LOCATE_PATH=/var/cache/locatedb

# Include the various profiles in the appropriate environment variables.
NIX_USER_PROFILE_DIR=/nix/var/nix/profiles/per-user/$USER
NIX_PROFILES="/var/run/current-system/sw /nix/var/nix/profiles/default $HOME/.nix-profile"

unset PATH INFOPATH PKG_CONFIG_PATH PERL5LIB ALSA_PLUGIN_DIRS GST_PLUGIN_PATH KDEDIRS
unset QT_PLUGIN_PATH QTWEBKIT_PLUGIN_PATH STRIGI_PLUGIN_PATH XDG_CONFIG_DIRS XDG_DATA_DIRS

for i in $NIX_PROFILES; do # !!! reverse
    # We have to care not leaving an empty PATH element, because that means '.' to Linux
    export PATH=$i/bin:$i/sbin:$i/lib/kde4/libexec${PATH:+:}$PATH
    export INFOPATH=$i/info:$i/share/info${INFOPATH:+:}$INFOPATH
    export PKG_CONFIG_PATH="$i/lib/pkgconfig${PKG_CONFIG_PATH:+:}$PKG_CONFIG_PATH"

    # terminfo and reset TERM with new TERMINFO available
    export TERMINFO_DIRS=$i/share/terminfo${TERMINFO_DIRS:+:}$TERMINFO_DIRS
    export TERM=$TERM

    # "lib/site_perl" is for backwards compatibility with packages
    # from Nixpkgs <= 0.12.
    export PERL5LIB="$i/lib/perl5/site_perl:$i/lib/site_perl${PERL5LIB:+:}$PERL5LIB"

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

    # mozilla plugins
    export MOZ_PLUGIN_PATH=$i/lib/mozilla/plugins${MOZ_PLUGIN_PATH:+:}$MOZ_PLUGIN_PATH
done

# Search directory for Aspell dictionaries.
export ASPELL_CONF="dict-dir $HOME/.nix-profile/lib/aspell"

# ~/bin and the setuid wrappers override other bin directories.
export PATH=$HOME/bin:@wrapperDir@:$PATH

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

# Create the per-user garbage collector roots directory.
NIX_USER_GCROOTS_DIR=/nix/var/nix/gcroots/per-user/$USER
mkdir -m 0755 -p $NIX_USER_GCROOTS_DIR
if test "$(stat --printf '%u' $NIX_USER_GCROOTS_DIR)" != "$(id -u)"; then
    echo "WARNING: bad ownership on $NIX_USER_GCROOTS_DIR" >&2
fi

# Set up a default Nix expression from which to install stuff.
if test ! -e $HOME/.nix-defexpr -o -L $HOME/.nix-defexpr; then
    echo "creating $HOME/.nix-defexpr" >&2
    rm -f $HOME/.nix-defexpr
    mkdir $HOME/.nix-defexpr
    ln -s /etc/nixos/nixpkgs $HOME/.nix-defexpr/nixpkgs_sys
    if test "$USER" != root; then
        ln -s /nix/var/nix/gcroots/per-user/root/channels $HOME/.nix-defexpr/channels_root
    fi
fi

@shellInit@

# Some aliases.
alias ls="ls --color=tty"
alias ll="ls -l"
alias l="ls -alh"

# Read system-wide modifications.
if test -f /etc/profile.local; then
    . /etc/profile.local
fi

if [ -n "${BASH_VERSION:-}" ]; then
    . /etc/bashrc
fi
