{
  lib,
  rustPlatform,
  fetchCrate,
  docutils,
  installShellFiles,
  udevCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdevctl";
  version = "1.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Zh+Dj3X87tTpqT/weZMpf7f3obqikjPy9pi50ifp6wQ=";
  };

  # https://github.com/mdevctl/mdevctl/issues/111
  patches = [
    ./script-dir.patch
  ];

  cargoHash = "sha256-LG5UaSUTF6pVx7BBLiZ/OmAZNCKswFlTqHymg3bDkuc=";

  nativeBuildInputs = [
    docutils
    installShellFiles
    udevCheckHook
  ];

  doInstallCheck = true;

  postInstall = ''
    ln -s mdevctl $out/bin/lsmdev

    install -Dm444 60-mdevctl.rules -t $out/lib/udev/rules.d

    installManPage $releaseDir/build/mdevctl-*/out/mdevctl.8
    ln -s mdevctl.8 $out/share/man/man8/lsmdev.8

    installShellCompletion $releaseDir/build/mdevctl-*/out/{lsmdev,mdevctl}.bash
  '';

  meta = with lib; {
    homepage = "https://github.com/mdevctl/mdevctl";
    description = "Mediated device management utility for linux";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };
}
