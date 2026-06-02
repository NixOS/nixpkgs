{
  lib,
  stdenv,
  fetchFromGitHub,
  tcl,
  tk,
  m4,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netgen";
  version = "1.5.319";

  src = fetchFromGitHub {
    owner = "RTimothyEdwards";
    repo = "netgen";
    tag = finalAttrs.version;
    hash = "sha256-n6UoxoPfUlWrl/3HFEXsZTl+nSTjUzK9WSt4q1kXrZs=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    m4
  ];

  buildInputs = [
    tcl
    tk
  ];

  env.NIX_CFLAGS_COMPILE = "-std=gnu89";

  configureFlags = [
    "--with-tcl=${lib.getLib tcl}/lib"
    "--with-tk=${lib.getLib tk}/lib"
  ];

  # Netgen generates a wrapper script with a hardcoded /bin/bash shebang.
  # We fix it here because patchShebangs sometimes misses it in post-install.
  postFixup = ''
    sed -i "1s|#!/bin/bash|#!${stdenv.shell}|" $out/bin/netgen
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "LVS tool for VLSI circuit netlists";
    mainProgram = "netgen";
    homepage = "https://github.com/RTimothyEdwards/netgen";
    license = lib.licenses.gpl1Only;
    maintainers = [ lib.maintainers.gonsolo ];
  };
})
