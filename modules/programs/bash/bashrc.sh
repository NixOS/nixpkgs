if [ -n "$NOSYSBASHRC" ]; then
    return
fi

# Initialise a bunch of environment variables.
export LD_LIBRARY_PATH=/var/run/opengl-driver/lib
export MODULE_DIR=@modulesTree@/lib/modules
export NIXPKGS_CONFIG=/nix/etc/config.nix
export NIXPKGS_ALL=/etc/nixos/nixpkgs
export PAGER="less -R"
export EDITOR=nano
export LOCATE_PATH=/var/cache/locatedb


# Include the various profiles in the appropriate environment variables.
NIX_USER_PROFILE_DIR=/nix/var/nix/profiles/per-user/$USER

NIX_PROFILES="/var/run/current-system/sw /nix/var/nix/profiles/default $NIX_USER_PROFILE_DIR/profile"

unset PATH INFOPATH PKG_CONFIG_PATH PERL5LIB GST_PLUGIN_PATH KDEDIRS
unset XDG_CONFIG_DIRS XDG_DATA_DIRS

for i in $NIX_PROFILES; do # !!! reverse
    # We have to care not leaving an empty PATH element, because that means '.' to Linux
    export PATH=$i/bin:$i/sbin${PATH:+:}$PATH
    export INFOPATH=$i/info:$i/share/info${INFOPATH:+:}$INFOPATH
    export PKG_CONFIG_PATH="$i/lib/pkgconfig${PKG_CONFIG_PATH:+:}$PKG_CONFIG_PATH"

    # "lib/site_perl" is for backwards compatibility with packages
    # from Nixpkgs <= 0.12.
    export PERL5LIB="$i/lib/perl5/site_perl:$i/lib/site_perl${PERL5LIB:+:}$PERL5LIB"

    # GStreamer.
    export GST_PLUGIN_PATH="$i/lib/gstreamer-0.10${GST_PLUGIN_PATH:+:}$GST_PLUGIN_PATH"

    # KDE/Gnome stuff.
    export KDEDIRS=$i${KDEDIRS:+:}$KDEDIRS
    export QT_PLUGIN_PATH=$i/plugins:$i/lib/qt4/plugins${QT_PLUGIN_PATH:+:}$QT_PLUGIN_PATH
    export XDG_CONFIG_DIRS=$i/etc/xdg${XDG_CONFIG_DIRS:+:}$XDG_CONFIG_DIRS
    export XDG_DATA_DIRS=$i/share${XDG_DATA_DIRS:+:}$XDG_DATA_DIRS
done
@shellInit@


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

# The "non-interactive" Bash build does not support programmable
# completion so check whether it's available.
if false; then
#if shopt -q progcomp 2> /dev/null; then
    # Completion.
    if [ -z "$BASH_COMPLETION_DIR" -a -d "@bash@/etc/bash_completion.d" ]; then
	BASH_COMPLETION_DIR="@bash@/etc/bash_completion.d"
    fi
    if [ -z "$BASH_COMPLETION" -a -f "@bash@/etc/bash_completion" ]; then
	BASH_COMPLETION="@bash@/etc/bash_completion"
	source "$BASH_COMPLETION"
    fi
fi
