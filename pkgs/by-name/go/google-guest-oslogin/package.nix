{
  lib,
  stdenv,
  curl,
  fetchFromGitHub,
  json_c,
  nixosTests,
  pam,
}:

stdenv.mkDerivation rec {
  pname = "google-guest-oslogin";
  version = "20250821.00";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "guest-oslogin";
    rev = version;
    sha256 = "sha256-dvLr3rOzHs5gRbllxqmnkLlHUFYv9Hm2vz6AkwZoZy4=";
  };

  postPatch = ''
    # change sudoers dir from /var/google-sudoers.d to /run/google-sudoers.d (managed through systemd-tmpfiles)
    substituteInPlace src/oslogin_utils.cc --replace-fail /var/google-sudoers.d /run/google-sudoers.d
    # fix "User foo not allowed because shell /bin/bash does not exist"
    substituteInPlace src/include/compat.h --replace-fail /bin/bash /run/current-system/sw/bin/bash
  '';

  buildInputs = [
    curl.dev
    pam
    json_c
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-I${json_c.dev}/include/json-c" ];

  makeFlags = [
    "VERSION=${version}"
    "PREFIX=$(out)"
    "MANDIR=$(out)/share/man"
    "SYSTEMDDIR=$(out)/etc/systemd/system"
    "PRESETDIR=$(out)/etc/systemd/system-preset"
  ];

  postInstall = ''
    sed -i "s,/usr/bin/,$out/bin/,g" $out/etc/systemd/system/google-oslogin-cache.service
  '';

  enableParallelBuilding = true;

  passthru.tests = {
    inherit (nixosTests) google-oslogin;
  };

  meta = with lib; {
    homepage = "https://github.com/GoogleCloudPlatform/compute-image-packages";
    description = "OS Login Guest Environment for Google Compute Engine";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
