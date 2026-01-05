{
  stdenv,
  lib,
  fetchFromGitHub,
  perl,
  which,
  rdkafka,
  jansson,
  curl,
  avro-c,
  avro-cpp,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "libserdes";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = "libserdes";
    rev = "v${version}";
    hash = "sha256-zEBJD7DOhpxfkAPypCZhygA6uaXIdK4yXZtDiuGA5Yg=";
  };

  outputs = [
    "dev"
    "out"
  ];

  nativeBuildInputs = [
    perl
    which
  ];

  buildInputs = [
    rdkafka
    jansson
    curl
    avro-c
    avro-cpp
  ];

  configureFlags = [
    # avro-cpp public headers use at least C++17 features, but libserdes configure scripts
    # basically cap it at C++11. It's really unfortunate that we have to patch the configure scripts for this,
    # but this seems to be the most sensible way.
    # - NIX_CFLAGS_COMPILE - fails because of -Werror in compiler checks since --std=... has no effect for C compilers.
    # - CXXFLAGS without patching configure.self does nothing, because --std=c++11 is appended to the final flags, overriding
    #   everything specified manually.
    "--CXXFLAGS=${toString [ "--std=c++17" ]}"
  ];

  makeFlags = [
    "GEN_PKG_CONFIG=y"
  ];

  postPatch = ''
    patchShebangs configure lds-gen.pl
    # Don't append the standard to CXXFLAGS, since we want to set it higher for avro-cpp.
    substituteInPlace configure.self --replace-fail \
      'mkl_mkvar_append CXXFLAGS CXXFLAGS "--std=c++11"' \
      ":" # Do nothing, we set the standard ourselves.
  '';

  # Has a configure script but it’s not Autoconf so steal some bits from multiple-outputs.sh:
  setOutputFlags = false;

  preConfigure = ''
    configureFlagsArray+=(
      "--libdir=''${!outputLib}/lib"
      "--includedir=''${!outputInclude}/include"
    )
  '';

  preInstall = ''
    installFlagsArray+=("pkgconfigdir=''${!outputDev}/lib/pkgconfig")
  '';

  # Header files get installed with executable bit for some reason; get rid of it.
  postInstall = ''
    chmod -x ''${!outputInclude}/include/libserdes/*.h
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Schema-based serializer/deserializer C/C++ library with support for Avro and the Confluent Platform Schema Registry";
    homepage = "https://github.com/confluentinc/libserdes";
    license = licenses.asl20;
    maintainers = with maintainers; [ liff ];
    platforms = platforms.all;
  };
}
