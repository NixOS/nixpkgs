import subprocess


BASELINE_CFG = """# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.username = {
    isNormalUser = true;
    description = "fullname";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
"""


def test_baseline(
    mocker,
    run,
    mock_gettext_translation,
    mock_libcalamares,
    mock_getoutput,
    mock_check_output,
    mock_open_hwconf,
    mock_Popen,
):
    result = run()

    assert result is None, "nixos-install failed."

    mock_gettext_translation.assert_called_once_with(
        "calamares-python", localedir=mocker.ANY, languages=mocker.ANY, fallback=True
    )

    # libcalamares.job.setprogress(0.1)
    assert mock_libcalamares.job.setprogress.mock_calls[0] == mocker.call(0.1)

    # libcalamares.job.setprogress(0.18)
    assert mock_libcalamares.job.setprogress.mock_calls[1] == mocker.call(0.18)

    # version = ".".join(subprocess.getoutput(
    # ["nixos-version"]).split(".")[:2])[:5]
    assert mock_getoutput.mock_calls[0] == mocker.call(["nixos-version"])

    # The baseline configuration should not raise any warnings.
    mock_libcalamares.utils.warning.assert_not_called()

    # libcalamares.job.setprogress(0.25)
    assert mock_libcalamares.job.setprogress.mock_calls[2] == mocker.call(0.25)

    # subprocess.check_output(
    #     ["pkexec", "nixos-generate-config", "--root", root_mount_point], stderr=subprocess.STDOUT)
    assert mock_check_output.mock_calls[0] == mocker.call(
        ["pkexec", "nixos-generate-config", "--root", "/mnt/root"],
        stderr=subprocess.STDOUT,
    )

    # hf = open(root_mount_point + "/etc/nixos/hardware-configuration.nix", "r")
    mock_open_hwconf.assert_called_once_with(
        "/mnt/root/etc/nixos/hardware-configuration.nix", "r"
    )

    # libcalamares.utils.host_env_process_output(
    #     ["cp", "/dev/stdin", config], None, cfg)
    mock_libcalamares.utils.host_env_process_output.assert_called_once_with(
        ["cp", "/dev/stdin", "/mnt/root/etc/nixos/configuration.nix"], None, mocker.ANY
    )
    cfg = mock_libcalamares.utils.host_env_process_output.call_args[0][2]
    assert cfg == BASELINE_CFG

    # libcalamares.job.setprogress(0.3)
    assert mock_libcalamares.job.setprogress.mock_calls[3] == mocker.call(0.3)

    # proc = subprocess.Popen(["pkexec", "nixos-install", "--no-root-passwd", "--root", root_mount_point], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    mock_Popen.assert_called_once_with(
        ["pkexec", "nixos-install", "--no-root-passwd", "--root", "/mnt/root"],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
