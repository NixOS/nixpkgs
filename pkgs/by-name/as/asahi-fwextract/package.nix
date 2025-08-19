{
  lib,
  python3,
  fetchFromGitHub,
  gzip,
  gnutar,
  lzfse,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "asahi-fwextract";
  version = "0.7.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "asahi-installer";
    tag = "v${version}";
    hash = "sha256-vbhepoZ52k5tW2Gd7tfQTZ5CLqzhV7dUcVh6+AYwECk=";
  };

  postPatch = ''
    substituteInPlace asahi_firmware/img4.py \
      --replace-fail 'liblzfse.so' '${lzfse}/lib/liblzfse.so'
    substituteInPlace asahi_firmware/update.py \
      --replace-fail '"tar"' '"${gnutar}/bin/tar"' \
      --replace-fail '"xf"' '"-x", "-I", "${gzip}/bin/gzip", "-f"'
  '';

  build-system = [ python3.pkgs.setuptools ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Asahi firmware extraction script";
    homepage = "https://github.com/AsahiLinux/asahi-installer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ normalcea ];
    mainProgram = "asahi-fwextract";
    platforms = [ "aarch64-linux" ];
  };
}
