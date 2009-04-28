# Initialise a bunch of environment variables.
export PATH=/var/run/current-system/sw/bin:/var/run/current-system/sw/sbin
export LD_LIBRARY_PATH=/var/run/opengl-driver/lib
if test -n "@nssModulesPath@"; then
    LD_LIBRARY_PATH=@nssModulesPath@:$LD_LIBRARY_PATH
fi
export MODULE_DIR=@modulesTree@/lib/modules
export NIXPKGS_CONFIG=/nix/etc/config.nix
export NIXPKGS_ALL=/etc/nixos/nixpkgs
export PAGER="less -R"
export TZ=@timeZone@
export TZDIR=@glibc@/share/zoneinfo
export FONTCONFIG_FILE=/etc/fonts/fonts.conf
export LANG=@defaultLocale@
export EDITOR=nano
export INFOPATH=/var/run/current-system/sw/info:/var/run/current-system/sw/share/info
export LOCATE_PATH=/var/cache/locatedb
@shellInit@
export LOCALE_ARCHIVE=/var/run/current-system/sw/lib/locale/locale-archive

# Set up secure multi-user builds: non-root users build through the
# Nix daemon.
if test "$USER" != root; then
    export NIX_REMOTE=daemon
else
    export NIX_REMOTE=
fi


# Set up the environment variables for running Nix.
@nixEnvVars@


# Include the various profiles in the appropriate environment variables.
NIX_USER_PROFILE_DIR=/nix/var/nix/profiles/per-user/$USER

NIX_PROFILES="/nix/var/nix/profiles/default $NIX_USER_PROFILE_DIR/profile"

for i in $NIX_PROFILES; do # !!! reverse
    export PATH=$i/bin:$i/sbin:$PATH
    export INFOPATH=$i/info:$i/share/info:$INFOPATH
    export PKG_CONFIG_PATH="$i/lib/pkgconfig:$PKG_CONFIG_PATH"

    # Automake's `aclocal' bails out if it finds non-existent directories
    # in its path.  !!! This has been fixed in the stdenv branch.
    if [ -d "$i/share/aclocal" ]; then
        export ACLOCAL_PATH="$i/share/aclocal:$ACLOCAL_PATH"
    fi

    export PERL5LIB="$i/lib/site_perl:$PERL5LIB"

    # GStreamer.
    export GST_PLUGIN_PATH="$i/lib/gstreamer-0.10:$GST_PLUGIN_PATH"

    # KDE/Gnome stuff.
    export KDEDIRS=$i:$KDEDIRS
    export XDG_CONFIG_DIRS=$i/etc/xdg:$XDG_CONFIG_DIRS
    export XDG_DATA_DIRS=$i/share:$XDG_DATA_DIRS
done


# Search directory for Aspell dictionaries.
export ASPELL_CONF="dict-dir $NIX_USER_PROFILE_DIR/profile/lib/aspell"


# ~/bin and the setuid wrappers override other bin directories.
export PATH=$HOME/bin:@wrapperDir@:$PATH


# Provide a nice prompt.
PROMPT_COLOR="1;31m"
let $UID && PROMPT_COLOR="1;32m"
PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
if test "$TERM" = "xterm"; then
    PS1="\033]2;\h:\u:\w\007$PS1"
fi


# Some aliases.
alias ls="ls --color=tty"
alias ll="ls -l"
alias l="ls -alh"
alias which="type -p"


# Help `rpcgen' find `cpp', assuming it's installed in the user's environment.
alias rpcgen="rpcgen -Y $HOME/.nix-profile/bin"
