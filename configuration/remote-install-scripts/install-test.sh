#! /bin/sh -i 

if test -z "$INSTALL_TEST_RUNNING" ; then
    export INSTALL_TEST_RUNNING=1;
    export ORIGINAL_NAME="$0";
    sh -i < "$ORIGINAL_NAME";
    exit;
fi;

if ! eval ' ( sleep 0.1; exit 0; ) & fg ' ; then
    echo "Failing job control test";
    exit;
fi;

set -x 

echo "Installation starting.." > report

nix-build -o socat /etc/nixos/nixpkgs -A socat || { echo "Failed to build socat" >&2 ;  exit 2; };
nix-build -o qemu /etc/nixos/nixpkgs -A qemu || { echo "Failed to build qemu" >&2 ;  exit 2; };

echo "reboot" | ./socat/bin/socat tcp-listen:4424 stdio >> report &  

if ( ! [ -d dvd/iso ] ) || ( [ -z "$USE_LEFTOVER_DVD" ] ); then
    rm dvd
    nix-build -o dvd /etc/nixos/nixos/configuration/closed-install.nix || 
      { echo "Failed to build LiveDVD" >&2 ;  exit 2; };
fi;

if ( ! [ -f install-test.img ] ) || ( [ -z "$JUST_BOOT" ] ); then
    rm install-test.img
    ./qemu/bin/qemu-img create -f qcow2 install-test.img 5G

    ./qemu/bin/qemu --kernel-kqemu -m 512 -cdrom dvd/iso/nixos-*.iso -hda install-test.img -boot d -no-reboot &
    ./socat/bin/socat tcp-listen:4425 tcp-listen:3737 &
    sleep 1;

    sed -e '/^127[.]0[.]0[.]1/d; /^\[127[.]0[.]0[.]1/d' -i ~/.ssh/known_hosts || true;

    (
        echo "cat > install-script.sh <<BIGEOF"
        cat $(dirname "$ORIGINAL_NAME")/install-script.sh
        echo BIGEOF

        echo "cat > install-start.sh <<BIGEOF"
        cat $(dirname "$ORIGINAL_NAME")/install-start.sh 
        echo BIGEOF

        echo 'chmod a+x *.sh'
        echo './install-start.sh'
    ) | ssh -l root -i /var/certs/ssh/id_livedvd -o StrictHostKeyChecking=no 127.0.0.1 -p 4425
fi;

./qemu/bin/qemu --kernel-kqemu -m 512 install-test.img -no-reboot 

echo "Report contains: "
cat report

set +x

if [ -n "$GC_DVD" ] ; then 
    rm dvd; nix-store --delete $(readlink -f dvd);
fi;

if [ -n "$DO_CLEANUP" ]; then
    rm dvd ; rm socat ; rm qemu ; rm install-test.img ;
fi;

test OK = "$(tail -1 report)";

