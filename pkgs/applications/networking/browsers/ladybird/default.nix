{ lib
, gcc11Stdenv
, fetchFromGitHub
, cmake
, ninja
, unzip
, wrapQtAppsHook
, makeWrapper
, qtbase
, qttools
}:

let serenity = fetchFromGitHub {
  owner = "SerenityOS";
  repo = "serenity";
  rev = "094ba6525f0217f3b8d5e467cef326caeb659e8a";
  hash = "sha256-IHXe2Td9iRSL1oQVwL2gZHxEM2ID4SghZwK6ewjFV1Y=";
};

in gcc11Stdenv.mkDerivation {
  pname = "ladybird";
  version = "unstable-2022-07-20";

  # Remember to update `serenity` too!
  src = fetchFromGitHub {
    owner = "awesomekling";
    repo = "ladybird";
    rev = "9e3a1f47d484cee6f23c4dae6c51750af155a8fc";
    hash = "sha256-1cPWpPvjM/VcVUEf2k+MvGvTgZ3Fc4LFHZCLh1wU78Y=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    unzip
    wrapQtAppsHook
    makeWrapper
  ];

  buildInputs = [
    qtbase
  ];

  cmakeFlags = [
    "-DSERENITY_SOURCE_DIR=${serenity}"
    # Disable network operations
    "-DENABLE_TIME_ZONE_DATABASE_DOWNLOAD=false"
    "-DENABLE_UNICODE_DATABASE_DOWNLOAD=false"
  ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

  # Upstream install rules are missing
  # https://github.com/awesomekling/ladybird/issues/36
  installPhase = ''
    runHook preInstall
    install -Dm755 ladybird $out/bin/ladybird
    mkdir -p $out/lib/ladybird
    cp -d _deps/lagom-build/*.so* $out/lib/ladybird/
    runHook postInstall
  '';

  # Patch rpaths
  # https://github.com/awesomekling/ladybird/issues/36
  preFixup = ''
    for f in $out/bin/ladybird $out/lib/ladybird/*.so; do
      old_rpath=$(patchelf --print-rpath "$f")
      # Remove reference to libraries from build directory
      rpath_without_build=$(sed -e 's@[^:]*/_deps/lagom-build:@@g' <<< $old_rpath)
      # Add directory where we install those libraries
      new_rpath=$out/lib/ladybird:$rpath_without_build
      patchelf --set-rpath "$new_rpath" "$f"
    done
  '';

  # According to the readme, the program needs access to the serenity sources
  # at runtime
  postFixup = ''
    wrapProgram $out/bin/ladybird --set SERENITY_SOURCE_DIR "${serenity}"
  '';

  # Stripping results in a symbol lookup error
  dontStrip = true;

  meta = with lib; {
    description = "A browser using the SerenityOS LibWeb engine with a Qt GUI";
    homepage = "https://github.com/awesomekling/ladybird";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fgaz ];
    # SerenityOS only works on x86, and can only be built on unix systems.
    # We also use patchelf in preFixup, so we restrict that to linux only.
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
