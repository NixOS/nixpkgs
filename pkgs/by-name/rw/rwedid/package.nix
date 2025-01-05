{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  xz,
}:

rustPlatform.buildRustPackage rec {
  pname = "rwedid";
  version = "0.3.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ral";
    repo = "rwedid";
    rev = version;
    hash = "sha256-lbZD/QLCgkD5OQZdn6oCjry9edMcJ+q9qGF7IbY36U4=";
  };

  cargoHash = "sha256-eY12p8pyUjSaoP4QKfVFwKQGdvFNG7GMAbFkFa8i05I=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    xz
  ];

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    echo 'SUBSYSTEM=="i2c-dev",KERNEL=="i2c-[0-9]*", ATTRS{class}=="0x030000", TAG+="uaccess"' > $out/etc/udev/rules.d/60-rwedid.rules
  '';

  meta = with lib; {
    description = "Read and write EDID data over an I2C bus";
    longDescription = ''
      To install udev rules, you also have to add `services.udev.packages = [ pkgs.rwedid ]` into your configuration.
      Additionally you will also have to create the i2c group, on NixOS this can be done using `users.groups.i2c = {};`.
      And you will have to load i2c-dev kernel module, for that add `boot.initrd.availableKernelModules = [ i2c-dev ] to your config.
    '';
    homepage = "https://codeberg.org/ral/rwedid";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
