{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "AutomaticComponentToolkit";
  version = "1.6.0-unstable-2023-09-04";

  # go.mod only exists after the v1.6.0 tag
  src = fetchFromGitHub {
    owner = "Autodesk";
    repo = "AutomaticComponentToolkit";
    rev = "33422936d34156d0d683e8ab363a8e10b14491c6";
    hash = "sha256-dyu0MOrJbcf6rDYLSkZsDgHEmZPkdGwVCaDc6pSXARo=";
  };

  vendorHash = null;

  subPackages = [ "Source" ];

  postInstall = ''
    mv $out/bin/Source $out/bin/act
  '';

  meta = {
    description = "Toolkit to automatically generate software components: abstract API, implementation stubs and language bindings";
    mainProgram = "act";
    homepage = "https://github.com/Autodesk/AutomaticComponentToolkit";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
