{
  lib,
  stdenv,
  fetchurl,
  darwin,

  # Build runit-init as a static binary
  static ? false,
}:

stdenv.mkDerivation rec {
  pname = "runit";
  version = "2.2.0";

  src = fetchurl {
    url = "http://smarden.org/runit/${pname}-${version}.tar.gz";
    sha256 = "sha256-le9NKGi5eMcXn+R5AeXFeOEc8nPSkr1iCL06fMsCkpA=";
  };

  patches = [
    ./fix-ar-ranlib.patch
  ];

  outputs = [
    "out"
    "man"
  ];

  sourceRoot = "admin/${pname}-${version}";

  doCheck = true;

  buildInputs =
    lib.optionals static [
      stdenv.cc.libc
      stdenv.cc.libc.static
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.libs.utmp;

  postPatch =
    ''
      sed -i "s,\(#define RUNIT\) .*,\1 \"$out/bin/runit\"," src/runit.h
      # usernamespace sandbox of nix seems to conflict with runit's assumptions
      # about unix users. Therefor skip the check
      sed -i '/.\/chkshsgr/d' src/Makefile
    ''
    + lib.optionalString (!static) ''
      sed -i 's,-static,,g' src/Makefile
    '';

  preBuild = ''
    cd src

    # Both of these are originally hard-coded to gcc
    echo ${stdenv.cc.targetPrefix}cc > conf-cc
    echo ${stdenv.cc.targetPrefix}cc ${lib.optionalString stdenv.hostPlatform.isDarwin "-Xlinker -x "}> conf-ld
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -t $out/bin $(< ../package/commands)

    mkdir -p $man/share/man
    cp -r ../man $man/share/man/man8
  '';

  meta = with lib; {
    description = "UNIX init scheme with service supervision";
    license = licenses.bsd3;
    homepage = "http://smarden.org/runit";
    maintainers = with maintainers; [ joachifm ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
