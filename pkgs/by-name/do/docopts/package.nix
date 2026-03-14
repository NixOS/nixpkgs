{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  bash,
  gawk,
  gnugrep,
  gnused,
}:
buildGoModule (finalAttrs: {
  pname = "docopts";
  version = "0.6.4-with-no-mangle-double-dash";

  src = fetchFromGitHub {
    owner = "docopt";
    repo = "docopts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GIBrJ5qexeJ6ul5ek9LJZC4J3cNExsTrnxdzRCfoqn8=";
  };

  patches = [
    # Migrate project to Go modules.
    (fetchpatch {
      url = "https://github.com/docopt/docopts/pull/74/commits/2c516165e72b35516a64c4529dbc938c0aaa9442.patch";
      hash = "sha256-Tp05B3tmctnSYIQzCxCc/fhcAWWuEz2ifu/CQZt0XPU=";
    })
  ];

  vendorHash = "sha256-+pMgaHB69itbQ+BDM7/oaJg3HrT1UN+joJL7BO/2vxE=";

  # Only build the main CLI; json_t and test_json_load are test/helper binaries
  subPackages = [ "." ];

  # Install docopts.sh in PATH to allow sourcing, and replace any binary reference
  # with nixpkgs binary paths.
  postInstall = ''
    install -D -m 444 $src/docopts.sh $out/bin/docopts.sh
    substituteInPlace $out/bin/docopts.sh \
      --replace-fail '#!/usr/bin/env bash' '#!${bash}/bin/bash'
    # Replace commands only in non-comment lines.
    while IFS= read -r line; do
      if [[ "$line" =~ ^[[:space:]]*# ]]; then
        printf '%s\n' "$line"
      else
        line="''${line// awk / ${gawk}/bin/awk }"
        line="''${line//sed / ${gnused}/bin/sed }"
        line="''${line// docopts / $out/bin/docopts }"
        line="''${line//'| grep "'/'| ${gnugrep}/bin/grep "'}"
        printf '%s\n' "$line"
      fi
    done < $out/bin/docopts.sh > $out/bin/docopts.sh.tmp
    mv $out/bin/docopts.sh.tmp $out/bin/docopts.sh
  '';

  meta = {
    homepage = "https://github.com/docopt/docopts";
    description = "Shell interpreter for docopt, the command-line interface description language";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.confus ];
    platforms = lib.platforms.unix;
  };
})
