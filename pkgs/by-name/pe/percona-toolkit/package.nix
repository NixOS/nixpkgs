{
  stdenv,
  lib,
  perlPackages,
  makeWrapper,
}:

let
  perconaToolkit = perlPackages.PerconaToolkit;
in

stdenv.mkDerivation {
  pname = perconaToolkit.name;
  version = perconaToolkit.version;

  nativeBuildInputs = [ makeWrapper ];

  src = perconaToolkit;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    # make sure dest already exists before symlink
    # this prevents installing a broken link into the path
    ln -s ${perconaToolkit}/lib $out/lib
    ln -s ${perconaToolkit}/share $out/share

    for cmd in ${perconaToolkit}/bin/*; do
        ln -s $cmd $out/bin
    done
  '';

  dontStrip = true;
  postFixup = ''
    for cmd in $out/bin/*; do
        wrapProgram $cmd --prefix PERL5LIB
    done
  '';

  meta = {
    inherit (perconaToolkit.meta)
      description
      homepage
      license
      platforms
      changelog
      ;

    maintainers = with lib.maintainers; [ michaelglass ];
  };
}
