{
  bash,
  coreutils,
  fetchFromGitHub,
  lib,
  python39,
  substituteAll,
}:

let
  inherit (lib) makeBinPath;
  # the latest python version that waagent test against according to https://github.com/Azure/WALinuxAgent/blob/28345a55f9b21dae89472111635fd6e41809d958/.github/workflows/ci_pr.yml#L75
  python = python39;

in
python.pkgs.buildPythonApplication rec {
  pname = "waagent";
  version = "2.10.0.8";
  src = fetchFromGitHub {
    owner = "Azure";
    repo = "WALinuxAgent";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Ilm29z+BJToVxdJTUAZO3Lr2DyOIvK6GW79GxAmfeM4=";
  };
  patches = [
    # Suppress the following error when waagent tries to configure sshd:
    # Read-only file system: '/etc/ssh/sshd_config'
    ./dont-configure-sshd.patch
  ];
  doCheck = false;

  # azure-product-uuid chmod rule invokes chmod to change the mode of
  # product_uuid (which is not a device itself).
  # Replace this with an absolute path.
  postPatch = ''
    substituteInPlace config/99-azure-product-uuid.rules \
      --replace "/bin/chmod" "${coreutils}/bin/chmod"
  '';

  propagatedBuildInputs = [ python.pkgs.distro ];

  # The udev rules are placed to the wrong place.
  # Move them to their default location.
  # Keep $out/${python.sitePackages}/usr/sbin/waagent where it is.
  # waagent re-executes itself in UpdateHandler.run_latest, even if autoupdate
  # is disabled, manually spawning a python interprever with argv0.
  # We can't use the default python program wrapping mechanism, as it uses
  # wrapProgram which doesn't support --argv0.
  # So instead we make our own wrapper in $out/bin/waagent, setting PATH and
  # PYTHONPATH.
  # PATH contains our PYTHON, and PYTHONPATH stays set, so this should somewhat
  # still work.
  preFixup = ''
    mv $out/${python.sitePackages}/etc $out/

    buildPythonPath

    mkdir -p $out/bin
    makeWrapper $out/${python.sitePackages}/usr/sbin/waagent $out/bin/waagent \
      --set PYTHONPATH $PYTHONPATH \
      --prefix PATH : $program_PATH \
      --argv0 $out/${python.sitePackages}/usr/sbin/waagent
  '';

  dontWrapPythonPrograms = false;

  meta = {
    description = "The Microsoft Azure Linux Agent (waagent)";
    mainProgram = "waagent";
    longDescription = ''
      The Microsoft Azure Linux Agent (waagent)
      manages Linux provisioning and VM interaction with the Azure
      Fabric Controller'';
    homepage = "https://github.com/Azure/WALinuxAgent";
    license = with lib.licenses; [ asl20 ];
  };
}
