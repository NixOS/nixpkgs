{ lib, makeImpureTest, coreutils, amdvlk, vulkan-tools }:
makeImpureTest {
  name = "amdvlk";
  testedPackage = "amdvlk";

  sandboxPaths = [ "/sys" "/dev/dri" ];

  nativeBuildInputs = [ vulkan-tools ];

  VK_ICD_FILENAMES = "${amdvlk}/share/vulkan/icd.d/amd_icd64.json";
  XDG_RUNTIME_DIR = "/tmp";

  # AMDVLK needs access to /dev/dri/card0 (or another card), but normally it is rw-rw----
  # Change the permissions to be rw for everyone
  prepareRunCommands = ''
    function reset_perms()
    {
      # Reset permissions to previous state
      for card in /dev/dri/card*; do
        sudo ${coreutils}/bin/chmod "0''${cardPerms[$card]}" $card
      done
    }

    # Save permissions on /dev/dri/card*
    declare -A cardPerms
    for card in /dev/dri/card*; do
      cardPerms[$card]=$(stat -c "%a" $card)
    done

    sudo ${coreutils}/bin/chmod o+rw /dev/dri/card*
    trap reset_perms EXIT
  '';

  testScript = ''
    # Check that there is at least one card with write-access
    if ! ls -l /dev/dri/card* | cut -b8-9 | grep -q rw; then
      echo 'AMDVLK needs rw access to /dev/dri/card0 or a fitting card, please run `sudo chmod o+rw /dev/dri/card*`'
      exit 1
    fi

    vulkaninfo --summary
    echo "Checking version"
    vulkaninfo --summary | grep '= ${amdvlk.version}'
  '';

  meta = with lib.maintainers; {
    maintainers = [ Flakebi ];
  };
}
