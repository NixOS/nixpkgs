#! @shell@

export PATH=/empty
for i in @path@; do PATH=$PATH:$i/bin; done


# Set up the statically computed bits of /etc.
staticEtc=/etc/static
rm -f $staticEtc
ln -s @etc@/etc $staticEtc
for i in $(cd $staticEtc && find * -type l); do
    mkdir -p /etc/$(dirname $i)
    rm -f /etc/$i
    ln -s $staticEtc/$i /etc/$i
done


# Remove dangling symlinks that point to /etc/static.  These are
# configuration files that existed in a previous configuration but not
# in the current one.
for i in $(find /etc/ -type l); do
    target=$(readlink "$i")
    if test "${target:0:${#staticEtc}}" = "$staticEtc" -a ! -e "$i"; then
        rm -f "$i"
    fi
done


# Various log directories.
mkdir -m 0755 -p /var/run

echo -n > /var/run/utmp # must exist
chmod 664 /var/run/utmp

mkdir -m 0755 -p /var/log


# Enable a password-less root login.
source @accounts@

if ! test -e /etc/passwd; then
    if test -n "@readOnlyRoot@"; then
        rootHome=/
    else
        rootHome=/home/root
        mkdir -p $rootHome
    fi
    createUser root '' 0 0 'System administrator' $rootHome/var/empty @shell@
fi

if ! test -e /etc/group; then
    echo "root:*:0" > /etc/group
fi


# Set up Nix accounts.
if test -z "@readOnlyRoot@"; then

    for i in $(seq 1 10); do
        account=nixbld$i
        if ! userExists $account; then
            createUser $account x \
                $((i + 30000)) 30000 \
                'Nix build user' /var/empty /noshell
        fi
        accounts="$accounts${accounts:+,}$account"
    done

    if ! grep -q "^nixbld:" /etc/group; then
        echo "nixbld:*:30000:$accounts" >> /etc/group
    fi

    mkdir -p /nix/etc/nix
    cat > /nix/etc/nix/nix.conf <<EOF
build-users-group = nixbld
EOF

    chown root.nixbld /nix/store
    chmod 1775 /nix/store
fi


# Additional path for the interactive shell.
PATH=@wrapperDir@:@fullPath@/bin:@fullPath@/sbin

cat > /etc/profile <<EOF
export PATH=$PATH
export MODULE_DIR=@kernel@/lib/modules
export NIX_CONF_DIR=/nix/etc/nix
if test "\$USER" != root; then
    export NIX_REMOTE=daemon
fi

source $(dirname $(readlink -f $(type -tp nix-env)))/../etc/profile.d/nix.sh

alias ll="ls -l"

if test -f /etc/profile.local; then
    source /etc/profile.local
fi
EOF


# Nix initialisation.
mkdir -m 0755 -p /nix/var/nix/db
mkdir -m 0755 -p /nix/var/nix/gcroots
mkdir -m 0755 -p /nix/var/nix/temproots

ln -sf /nix/var/nix/profiles /nix/var/nix/gcroots/

chown root.nixbld /nix/store
chmod 1775 /nix/store


# Make a few setuid programs work.
wrapperDir=@wrapperDir@
if test -d $wrapperDir; then rm -f $wrapperDir/*; fi
mkdir -p $wrapperDir
for i in passwd su; do
    program=$(type -tp $i)
    cp $(type -tp setuid-wrapper) $wrapperDir/$i
    echo -n $program > $wrapperDir/$i.real
    chown root.root $wrapperDir/$i
    chmod 4755 $wrapperDir/$i
done


# Set the host name.
hostname @hostName@
