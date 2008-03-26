export PATH=@wrapperDir@:/var/run/current-system/sw/bin:/var/run/current-system/sw/sbin
export LD_LIBRARY_PATH=@nssModulesPath@:/var/run/current-system/sw/lib
export MODULE_DIR=@modulesTree@/lib/modules
export NIXPKGS_CONFIG=/nix/etc/config.nix
export PAGER="less -R"
export TZ=@timeZone@
export TZDIR=@glibc@/share/zoneinfo
export FONTCONFIG_FILE=/etc/fonts/fonts.conf
export LANG=@defaultLocale@
export EDITOR=nano
export INFOPATH=/var/run/current-system/sw/info:/var/run/current-system/sw/share/info
export LOCATE_PATH=/var/cache/locatedb


# Set up secure multi-user builds: non-root users build through the
# Nix daemon.
if test "$USER" != root; then
    export NIX_REMOTE=daemon
else
    export NIX_REMOTE=
fi


# Set up the environment variables for running Nix.
@nixEnvVars@


# Set up the per-user profile.
NIX_USER_PROFILE_DIR=/nix/var/nix/profiles/per-user/$USER
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

NIX_PROFILES="/nix/var/nix/profiles/default $NIX_USER_PROFILE_DIR/profile"

for i in $NIX_PROFILES; do # !!! reverse
    export PATH=$i/bin:$i/sbin:$PATH
    export INFOPATH=$i/info:$i/share/info:$INFOPATH
    export PKG_CONFIG_PATH="$i/lib/pkgconfig:$PKG_CONFIG_PATH"
    export ACLOCAL_PATH="$i/share/aclocal:$ACLOCAL_PATH"
done

# Search directory for Aspell dictionaries.
export ASPELL_CONF="dict-dir $NIX_USER_PROFILE_DIR/profile/lib/aspell"

export PATH=$HOME/bin:$PATH


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
    ln -s /etc/nixos/nixos $HOME/.nix-defexpr/nixos
    if test "$USER" != root; then
        ln -s /nix/var/nix/gcroots/per-user/root/channels $HOME/.nix-defexpr/channels_root
    fi
fi

# Include bashrc settings

source /etc/bashrc

# Read system-wide modifications.
if test -f /etc/profile.local; then
    source /etc/profile.local
fi
