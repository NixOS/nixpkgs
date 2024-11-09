{ fetchurl, bash, glibc, lib, stdenv, installShellFiles }:

let
  man-pages = fetchurl {
    url = "https://salsa.debian.org/debian/daemontools/-/archive/debian/1%250.76-8/daemontools-debian-1%250.76-8.tar.gz?path=debian/daemontools-man";
    sha256 = "sha256-om5r1ddUx1uObp9LR+SwCLLtm+rRuLoq28OLbhWhdzU=";
  };
in
stdenv.mkDerivation rec {
  pname = "daemontools";
  version = "0.76";

  src = fetchurl {
    url = "https://cr.yp.to/daemontools/daemontools-${version}.tar.gz";
    sha256 = "07scvw88faxkscxi91031pjkpccql6wspk4yrlnsbrrb5c0kamd5";
  };

  patches = [ ./fix-nix-usernamespace-build.patch ];

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ installShellFiles ];

  configurePhase = ''
    cd daemontools-${version}

    sed -ie '1 s_$_ -include ${glibc.dev}/include/errno.h_' src/conf-cc

    substituteInPlace src/Makefile \
      --replace '/bin/sh' '${bash}/bin/bash -oxtrace'

    sed -ie "s_^PATH=.*_PATH=$src/daemontools-${version}/compile:''${PATH}_" src/rts.tests

    cat ${glibc.dev}/include/errno.h
  '';

  buildPhase = ''
    package/compile
  '';

  installPhase = ''
    for cmd in $(cat package/commands); do
      install -Dm755 "command/$cmd" "$out/bin/$cmd"
    done

    tar -xz --strip-components=2 -f ${man-pages}
    installManPage daemontools-man/*.8
    install -v -Dm644 daemontools-man/README $man/share/doc/daemontools/README.man
    # fix svscanboot
    sed -i "s_/command/__"                    "$out/bin/svscanboot"
    sed -i "s_/service_/var/service_g"        "$out/bin/svscanboot"
    sed -i "s_^PATH=.*_PATH=$out/bin:\$PATH_" "$out/bin/svscanboot"
  '';

  # Keep README.man in the man output (see _multioutDocs())
  outputDoc = "man";

  meta = {
    license = lib.licenses.publicDomain;
    homepage = "https://cr.yp.to/daemontools.html";
    description = "Collection of tools for managing UNIX services";

    maintainers = with lib.maintainers; [ kevincox ];
    platforms = lib.platforms.unix;
  };
}
