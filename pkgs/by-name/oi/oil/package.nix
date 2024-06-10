{ stdenv, lib, fetchurl, symlinkJoin, withReadline ? true, readline }:

let
  readline-all = symlinkJoin {
    name = "readline-all"; paths = [ readline readline.dev ];
  };
in
stdenv.mkDerivation rec {
  pname = "oil";
  version = "0.22.0";

  src = fetchurl {
    url = "https://www.oilshell.org/download/oil-${version}.tar.xz";
    hash = "sha256-RS5/1Ci2hqp1LP65viuU+fz3upqyLgrlcKh83PeCJC4=";
  };

  postPatch = ''
    patchShebangs build
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  strictDeps = true;
  buildInputs = lib.optional withReadline readline;
  # As of 0.20.0 the build generates an error on MacOS (using clang version 16.0.6 in the builder),
  # whereas running it outside of Nix with clang version 15.0.0 generates just a warning. The shell seems to
  # work just fine though, so we disable the error here.
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=incompatible-function-pointer-types";
  configureFlags = [
    "--datarootdir=${placeholder "out"}"
  ] ++ lib.optionals withReadline [
    "--with-readline"
    "--readline=${readline-all}"
  ];

  # Stripping breaks the bundles by removing the zip file from the end.
  dontStrip = true;

  meta = {
    description = "New unix shell - Python version";
    homepage = "https://www.oilshell.org/";

    license = with lib.licenses; [
      psfl # Includes a portion of the python interpreter and standard library
      asl20 # Licence for Oil itself
    ];

    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ lheckemann alva melkor333 ];
    changelog = "https://www.oilshell.org/release/${version}/changelog.html";
  };

  passthru = {
    shellPath = "/bin/osh";
  };
}
