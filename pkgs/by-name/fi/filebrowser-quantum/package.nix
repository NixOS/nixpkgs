{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  buildGoModule,
}:

let
  version = "0.7.9-beta";

  src = fetchFromGitHub {
    owner = "gtsteffaniak";
    repo = "filebrowser";
    rev = "v${version}";
    hash = "sha256-o6UoYYULnVgkXN9fNnTTNxF+i9pA7FuV31xfZppXMBE=";
  };

  frontend = buildNpmPackage (finalAttrs: {
    inherit version;
    src = "${src}/frontend";
    name = "filebrowser-quantum-frontend";

    npmDepsHash = "sha256-Hv/9X4ryE8QRJwHO19G7E4bwQXUisiQjuCxJBO8m87o=";
    # Thank you pkgs/by-name/di/dim/package.nix for this solution
    postPatch = ''
      ln -s ${./package-lock.json} package-lock.json
    '';

    # Manual invocation for later copying
    buildPhase = ''
      runHook preBuild
      npx vite build
      runHook postBuild
    '';
  });
in
buildGoModule {
  inherit version src;
  pname = "filebrowser-quantum";
  sourceRoot = "${src.name}/backend";

  vendorHash = "sha256-v7hYo2HIKonnNVGwOV8WiaWzo4FNSG5/8Ov3w/ivB+8=";

  excludedPackages = [ "tools" ];

  postPatch = ''
    cp -r ${frontend}/lib/node_modules/filebrowser-frontend/dist/* http/embed
  '';

  postInstall = ''
    mv $out/bin/backend $out/bin/filebrowser
  '';

  meta = with lib; {
    description = "FileBrowser Quantum provides an easy way to access and manage your files from the web";
    homepage = "https://github.com/gtsteffaniak/filebrowser";
    license = licenses.asl20;
    maintainers = with maintainers; [ denperidge ];
    mainProgram = "filebrowser";
  };
}
