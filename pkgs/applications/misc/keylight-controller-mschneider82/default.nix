{ buildGoModule, fetchFromGitHub, lib, libGL, nssmdns, pkg-config, xorg }:

buildGoModule rec {
  pname = "keylight-controller-mschneider82";
<<<<<<< HEAD
  version = "0.1.1";
=======
  version = "0.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mschneider82";
    repo = "keylight-control";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-xC/JRM8vyqAsxPpf37P3pZv6i73s+CLQt6Sh4nMxwzM=";
  };

  vendorHash = "sha256-nFttVJbEAAGsrAglMphuw0wJ2Kf8sWB4HrpVqfHO76o=";
=======
    sha256 = "sha256-UZfbGihCgFBQE1oExuzCexoNgpVGwNoA9orjZ9fh4gA=";
  };

  vendorSha256 = "sha256-nFttVJbEAAGsrAglMphuw0wJ2Kf8sWB4HrpVqfHO76o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libGL
    nssmdns
  ] ++ (with xorg; [
    libX11
    libX11.dev
    libXcursor
    libXext
    libXi
    libXinerama
    libXrandr
    libXxf86vm
    xinput
  ]);

  meta = with lib; {
    description = "A desktop application to control Elgato Keylights";
    longDescription = ''
      Requires having:
      * Elgato's Keylight paired to local wifi network.
      * Service avahi with nssmdns enabled.
    '';
    license = licenses.mit;
    homepage = "https://github.com/mschneider82/keylight-control";
    maintainers = with maintainers; [ ];
  };
}

# Note: Application errors on first executions but works on re-runs.

# Troubleshooting
# 1. Keylight lists at: `avahi-browse --all --resolve --ignore-local`
# 2. Ping Keylight's IP
# 3. Resolve Keylight's hostname: `getent hosts elgato-key-light-XXXX.local`
