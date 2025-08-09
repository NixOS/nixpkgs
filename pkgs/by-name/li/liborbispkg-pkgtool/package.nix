{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
}:
buildDotnetModule {
  pname = "liborbispkg-pkgtool";
  version = "0.3-unstable-2024-10-12";

  src = fetchFromGitHub {
    owner = "OpenOrbis";
    repo = "LibOrbisPkg";
    rev = "75616a28de0f49f05eeff872211e806fb6de3818";
    hash = "sha256-ySlMzUfJ0IXi/NWbj53jqCRDNm9Xh4TuffyKhNh4wuM=";
  };

  projectFile = "PkgTool.Core/PkgTool.Core.csproj";

  postFixup = ''
    mv $out/bin/PkgTool.Core $out/bin/pkgtool
  '';

  meta = {
    description = "Library, GUI, CLI for creating, inspecting, and modifying PS4 PKG, SFO, PFS, and related filetypes";
    homepage = "https://github.com/OpenOrbis/LibOrbisPkg";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.ryand56 ];
    mainProgram = "pkgtool";
  };
}
