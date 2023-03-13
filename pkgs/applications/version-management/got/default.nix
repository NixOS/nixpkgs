{ lib, stdenv, fetchurl
, pkg-config, openssl, libbsd, libevent, libuuid, libossp_uuid, libmd, zlib, ncurses, bison
}:

stdenv.mkDerivation rec {
  pname = "got";
  version = "0.86";

  src = fetchurl {
    url = "https://gameoftrees.org/releases/portable/got-portable-${version}.tar.gz";
    hash = "sha256-FHjLEkxsvkYz4tK1k/pEUfDT9rfvN+K68gRc8fPVp7A=";
  };

  nativeBuildInputs = [ pkg-config bison ];

  buildInputs = [ openssl libbsd libevent libuuid libmd zlib ncurses ]
  ++ lib.optionals stdenv.isDarwin [ libossp_uuid ];

  preConfigure = lib.optionalString stdenv.isDarwin ''
    # The configure script assumes dependencies on Darwin are installed via
    # Homebrew or MacPorts and hardcodes assumptions about the paths of
    # dependencies which fails the nixpkgs configurePhase.
    substituteInPlace configure --replace 'xdarwin' 'xhomebrew'
  '' + lib.optionalString stdenv.isLinux ''
    fgrep -Rl @HOST_FREEBSD_TRUE@ . | xargs sed -e 's,@HOST_FREEBSD_TRUE@,,' -i
  '';

  patches = lib.optionals stdenv.isDarwin [ ./darwin.patch ];

  preBuild = lib.optionalString stdenv.isDarwin ''
    buildFlagsArray+=(CFLAGS="-DHAVE_STRLCPY=1 -DHAVE_STRLCAT=1 -DHAVE_STRNSTR=1 -DHAVE_STRMODE=1")
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    test "$($out/bin/got --version)" = '${pname} ${version}'
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "A version control system which prioritizes ease of use and simplicity over flexibility";
    longDescription = ''
      Game of Trees (Got) is a version control system which prioritizes
      ease of use and simplicity over flexibility.

      Got uses Git repositories to store versioned data. Git can be used
      for any functionality which has not yet been implemented in
      Got. It will always remain possible to work with both Got and Git
      on the same repository.
    '';
    homepage = "https://gameoftrees.org";
    license = licenses.isc;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ abbe afh ];
  };
}
