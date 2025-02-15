{
  stdenv,
  lib,
  fetchurl,
  file,
}:

stdenv.mkDerivation rec {
  owner = "FilenCloudDienste";
  pname = "filen-cli";
  version = "0.0.19";

  # Define platform-specific source URL
  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://github.com/${owner}/${pname}/releases/download/v${version}/${pname}-v${version}-linux-x64";
        sha256 = "sha256-8y58HV82uDGhHDziCyhwcHaecactY331Ztbw+uq7oh4=";
      }
    else if stdenv.hostPlatform.system == "aarch64-linux" then
      fetchurl {
        url = "https://github.com/${owner}/${pname}/releases/download/v${version}/${pname}-v${version}-linux-arm64";
        sha256 = "sha256-Ee8MnwTKlHvZzK7PHoE9xft4WeeAw9qTnjk/1dcyhMY=";
      }

    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      fetchurl {
        url = "https://github.com/${owner}/${pname}/releases/download/v${version}/${pname}-v${version}-macos-x64";
        sha256 = "sha256-J721M6VE74iZYavp9VpzpMQSMsBB4fAlu7djgceMWE4=";
      }

    else if stdenv.hostPlatform.system == "x86_64-windows" then
      fetchurl {
        url = "https://github.com/${owner}/${pname}/releases/download/v${version}/${pname}-v${version}-win-x64";
        sha256 = "sha256-ra2qbveLypV2ztDobhhOSneD3ORkuCqNy7i0k6K/7yg=";
      }

    else
      throw "Unsupported platform: ${stdenv.hostPlatform.system}";

  buildInputs = [ file ];
  doCheck = false;

  unpackPhase = ":";
  configurePhase = ":";

  # create relevant dir for single binary
  buildPhase = # bash
    ''
      mkdir -p $out/bin
    '';

  # install built-in artifacts into $out
  installPhase = # bash
    ''
      cp $src $out/bin/${pname}
      chmod +x $out/bin/${pname}
    '';

  fixupPhase = ":";

  # verify the installed files
  installCheckPhase = # bash
    ''
      ls -al $out/bin/
      ${file} $out/bin/${pname}
    '';

  meta = with lib; {
    description = "A headless CLI that provides a set of useful tools for interacting with Filen cloud storage securely";
    longDescription = ''
      The filen-cli is a fully featured CLI that gives you access to your files using an interactive
      and scriptable CLI in a headless environment. Perfect for advanced users who want more control
      over their data from the terminal. Features include:
        - WebDAV and S3
        - Network drive mounting
        - Fast file management like 'ls', 'mv' and many more.
    '';
    homepage = "https://filen.io";
    license = licenses.agpl3Only;
    mainProgram = "filen-cli";
    platforms = platforms.unix;
    maintainers = [ maintainers.onahp ];
  };
}
