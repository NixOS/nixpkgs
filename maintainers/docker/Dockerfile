FROM busybox

RUN dir=`mktemp -d` && trap 'rm -rf "$dir"' EXIT && \
    wget -O- http://nixos.org/releases/nix/nix-1.7/nix-1.7-x86_64-linux.tar.bz2  | bzcat | tar x -C $dir && \
    mkdir -m 0755 /nix && USER=root sh $dir/*/install && \
    echo ". /root/.nix-profile/etc/profile.d/nix.sh" >> /etc/profile

ADD . /root/nix/nixpkgs
ONBUILD ENV NIX_PATH nixpkgs=/root/nix/nixpkgs:nixos=/root/nix/nixpkgs/nixos
ONBUILD ENV PATH /root/.nix-profile/bin:/root/.nix-profile/sbin:/bin:/sbin:/usr/bin:/usr/sbin
ONBUILD ENV ENV /etc/profile
ENV ENV /etc/profile
