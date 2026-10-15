{ pkgs, lib, ... }:
{
  name = "castopod";
  meta = with lib.maintainers; {
    maintainers = [ alexoundos ];
  };

  nodes.castopod =
    { nodes, ... }:
    {
      # otherwise 500 MiB file upload fails!
      virtualisation.diskSize = 512 + 3 * 512;

      networking.firewall.allowedTCPPorts = [ 80 ];
      networking.extraHosts = lib.strings.concatStringsSep "\n" (
        lib.attrsets.mapAttrsToList (
          name: _: "127.0.0.1 ${name}"
        ) nodes.castopod.services.nginx.virtualHosts
      );

      services.castopod = {
        enable = true;
        database.createLocally = true;
        localDomain = "castopod.example.com";
        maxUploadSize = "512M";
      };
    };

  nodes.client =
    {
      nodes,
      pkgs,
      lib,
      ...
    }:
    let
      domain = nodes.castopod.services.castopod.localDomain;

      getIP = node: (builtins.head node.networking.interfaces.eth1.ipv4.addresses).address;

      targetPodcastSize = 500 * 1024 * 1024;
      lameMp3Bitrate = 348300;
      lameMp3FileAdjust = -800;
      targetPodcastDuration = toString ((targetPodcastSize + lameMp3FileAdjust) / (lameMp3Bitrate / 8));
      bannerWidth = 3000;
      banner = pkgs.runCommand "gen-castopod-cover.jpg" { } ''
        ${pkgs.imagemagick}/bin/magick `
        `-background green -bordercolor white -gravity northwest xc:black `
        `-duplicate 99 `
        `-seed 1 -resize "%[fx:rand()*72+24]" `
        `-seed 0 -rotate "%[fx:rand()*360]" -border 6x6 -splice 16x36 `
        `-seed 0 -rotate "%[fx:floor(rand()*4)*90]" -resize "150x50!" `
        `+append -crop 10x1@ +repage -roll "+%[fx:(t%2)*72]+0" -append `
        `-resize ${toString bannerWidth} -quality 1 $out
      '';

      coverWidth = toString 3000;
      cover = pkgs.runCommand "gen-castopod-banner.jpg" { } ''
        ${pkgs.imagemagick}/bin/magick `
        `-background white -bordercolor white -gravity northwest xc:black `
        `-duplicate 99 `
        `-seed 1 -resize "%[fx:rand()*72+24]" `
        `-seed 0 -rotate "%[fx:rand()*360]" -border 6x6 -splice 36x36 `
        `-seed 0 -rotate "%[fx:floor(rand()*4)*90]" -resize "144x144!" `
        `+append -crop 10x1@ +repage -roll "+%[fx:(t%2)*72]+0" -append `
        `-resize ${coverWidth} -quality 1 $out
      '';
    in
    {
      networking.extraHosts = lib.strings.concatStringsSep "\n" (
        lib.attrsets.mapAttrsToList (
          name: _: "${getIP nodes.castopod} ${name}"
        ) nodes.castopod.services.nginx.virtualHosts
      );

      environment.systemPackages =
        let
          username = "admin";
          email = "admin@${domain}";
          password = "Abcd1234";
          podcastTitle = "Some Title";
          episodeTitle = "Episode Title";
          browser-test =
            pkgs.writers.writePython3Bin "browser-test"
              {
                libraries = [ pkgs.python3Packages.selenium ];
                flakeIgnore = [
                  "E124"
                  "E501"
                ];
              }
              ''
                from selenium.webdriver.common.by import By
                from selenium.webdriver import Firefox
                from selenium.webdriver.firefox.options import Options
                from selenium.webdriver.firefox.service import Service
                from selenium.webdriver.support.ui import WebDriverWait
                from selenium.webdriver.support import expected_conditions as EC
                from subprocess import STDOUT
                import logging

                selenium_logger = logging.getLogger("selenium")
                selenium_logger.setLevel(logging.DEBUG)
                selenium_logger.addHandler(logging.StreamHandler())

                options = Options()
                options.add_argument('--headless')
                service = Service(log_output=STDOUT)
                driver = Firefox(options=options, service=service)
                driver = Firefox(options=options)
                driver.implicitly_wait(30)
                driver.set_page_load_timeout(60)

                # install ##########################################################

                driver.get('http://${domain}/cp-install')

                wait = WebDriverWait(driver, 20)

                wait.until(EC.title_contains("installer"))

                driver.find_element(By.CSS_SELECTOR, '#username').send_keys(
                    '${username}'
                )
                driver.find_element(By.CSS_SELECTOR, '#email').send_keys(
                    '${email}'
                )
                driver.find_element(By.CSS_SELECTOR, '#password').send_keys(
                    '${password}'
                )
                driver.find_element(By.XPATH,
                                    "//button[contains(., 'Finish install')]"
                ).click()

                wait.until(EC.title_contains("Auth"))

                driver.find_element(By.CSS_SELECTOR, '#email').send_keys(
                    '${email}'
                )
                driver.find_element(By.CSS_SELECTOR, '#password').send_keys(
                    '${password}'
                )
                driver.find_element(By.XPATH,
                                    "//button[contains(., 'Login')]"
                ).click()

                wait.until(EC.title_contains("Admin dashboard"))

                # create podcast ###################################################

                driver.get('http://${domain}/admin/podcasts/new')

                wait.until(EC.title_contains("Create podcast"))

                driver.find_element(By.CSS_SELECTOR, '#cover').send_keys(
                    '${cover}'
                )
                driver.find_element(By.CSS_SELECTOR, '#banner').send_keys(
                    '${banner}'
                )
                driver.find_element(By.CSS_SELECTOR, '#title').send_keys(
                    '${podcastTitle}'
                )
                driver.find_element(By.CSS_SELECTOR, '#handle').send_keys(
                    'some_handle'
                )
                driver.find_element(By.CSS_SELECTOR, '#description').send_keys(
                    'Some description'
                )
                driver.find_element(By.CSS_SELECTOR, '#owner_name').send_keys(
                    'Owner Name'
                )
                driver.find_element(By.CSS_SELECTOR, '#owner_email').send_keys(
                    'owner@email.xyz'
                )
                driver.find_element(By.XPATH,
                                    "//button[contains(., 'Create podcast')]"
                ).click()

                wait.until(EC.title_contains("${podcastTitle}"))

                driver.find_element(By.XPATH,
                                    "//span[contains(., 'Add an episode')]"
                ).click()

                wait.until(EC.title_contains("Add an episode"))

                # upload podcast ###################################################

                driver.find_element(By.CSS_SELECTOR, '#audio_file').send_keys(
                    '/tmp/podcast.mp3'
                )
                driver.find_element(By.CSS_SELECTOR, '#cover').send_keys(
                    '${cover}'
                )
                driver.find_element(By.CSS_SELECTOR, '#description').send_keys(
                    'Episode description'
                )
                driver.find_element(By.CSS_SELECTOR, '#title').send_keys(
                    '${episodeTitle}'
                )
                driver.find_element(By.XPATH,
                                    "//button[contains(., 'Create episode')]"
                ).click()

                wait.until(EC.title_contains("${episodeTitle}"))

                driver.close()
                driver.quit()
              '';
        in
        [
          pkgs.firefox-unwrapped
          pkgs.geckodriver
          browser-test
          (pkgs.writeShellApplication {
            name = "build-mp3";
            runtimeInputs = with pkgs; [
              sox
              lame
            ];
            text = ''
              out=/tmp/podcast.mp3
              sox -n -r 48000 -t wav - synth ${targetPodcastDuration} sine 440 `
              `| lame --noreplaygain --cbr -q 9 -b 320 - $out
              FILESIZE="$(stat -c%s $out)"
              [ "$FILESIZE" -gt 0 ]
              [ "$FILESIZE" -le "${toString targetPodcastSize}" ]
            '';
          })
        ];
    };

  testScript = ''
    start_all()
    castopod.wait_for_unit("castopod-setup.service")
    castopod.wait_for_file("/run/phpfpm/castopod.sock")
    castopod.wait_for_unit("nginx.service")
    castopod.wait_for_open_port(80)
    castopod.wait_until_succeeds("curl -sS -f http://castopod.example.com")

    client.succeed("build-mp3")

    with subtest("Create superadmin, log in, create and upload a podcast"):
        client.succeed(\
          "PYTHONUNBUFFERED=1 systemd-cat -t browser-test browser-test")
  '';
}
