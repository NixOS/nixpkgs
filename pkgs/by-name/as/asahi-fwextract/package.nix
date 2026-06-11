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
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "asahi-installer";
    tag = "v${version}";
    hash = "sha256-UMzmQ3buXousCR8t0eSf6m+OTvqp3mEQ73aZ9UznuOI=";
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
    maintainers = [ ];
    mainProgram = "asahi-fwextract";
    platforms = [ "aarch64-linux" ];
  };
}
