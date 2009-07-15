# This file is executed by all login shells.  Don't ask what a login
# shell is, nobody knows.  Most global environment variables should go
# in /etc/bashrc, which is by default included by non-login shells,
# but which we include here as well.

source /etc/bashrc


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


# Read system-wide modifications.
if test -f /etc/profile.local; then
    source /etc/profile.local
fi
