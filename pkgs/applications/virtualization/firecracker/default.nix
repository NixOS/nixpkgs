{ fetchurl, lib, stdenv }:

let
<<<<<<< HEAD
  version = "1.4.0";
=======
  version = "1.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # nixpkgs-update: no auto update

  suffix = {
    x86_64-linux = "x86_64";
    aarch64-linux = "aarch64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  baseurl = "https://github.com/firecracker-microvm/firecracker/releases/download";

  dlbin = sha256: fetchurl {
    url = "${baseurl}/v${version}/firecracker-v${version}-${suffix}.tgz";
    sha256 = sha256."${stdenv.hostPlatform.system}";
  };

in
stdenv.mkDerivation {
  pname = "firecracker";
  inherit version;

  sourceRoot = ".";
  src = dlbin {
<<<<<<< HEAD
    x86_64-linux = "sha256-WSa8fd0OSPo1HFkH6i8cGMNH1df88xI6PCx39ONb73c=";
    aarch64-linux = "sha256-eOsO/nbwKT50tC5g6INPELh2yVb5C3EGqNLQLT7IGBs=";
=======
    x86_64-linux = "sha256-VfTo3TaTqqBYT2/CZW0F5tGXaT4CyBcKBnP5Xqc1BLI=";
    aarch64-linux = "sha256-ODIBa482X8bNhRyvdmIGGi/6BZYif02cf8tAWYRcI2k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontConfigure = true;

  buildPhase = ''
    mv release-v${version}-${suffix}/firecracker-v${version}-${suffix} firecracker
    mv release-v${version}-${suffix}/jailer-v${version}-${suffix} jailer
    chmod +x firecracker jailer
  '';

  doCheck = true;
  checkPhase = ''
    ./firecracker --version
    ./jailer --version
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -D firecracker $out/bin/firecracker
    install -D jailer      $out/bin/jailer
  '';

  meta = with lib; {
    description = "Secure, fast, minimal micro-container virtualization";
    homepage = "http://firecracker-microvm.io";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ thoughtpolice endocrimes ];
  };
}
