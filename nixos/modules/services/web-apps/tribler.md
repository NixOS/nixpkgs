# Tribler {#module-services-tribler}

[Tribler](https://www.tribler.org/), a privacy enhanced BitTorrent client with P2P content discovery

Tribler is a research project of Delft University of Technology. Tribler was created in April 2005 as a new open source Peer-to-Peer file sharing program. During this time over one million users have installed it successfully and three generations of Ph.D. students tested their algorithms in the real world.

Tribler is the first client which continuously improves upon the aging BitTorrent protocol from 2001 and addresses its flaws. We expanded it with, amongst others, streaming from magnet links, keyword search for content, channels and reputation-management. All these features are implemented in a completely distributed manner, not relying on any centralized component. Still, Tribler manages to remain fully backwards compatible with BitTorrent.

Work on Tribler has been supported by multiple Internet research European grants. In total we received 3,538,609 Euro in funding for our open source self-organising systems research.

Roughly 10 to 15 scientists and engineers work on it full-time. Our ambition is to make darknet technology, security and privacy the default for all Internet users. As of 2017 we have received code from 56 contributors and 146.003 lines of code.

**Vision & Mission**

"Push the boundaries of self-organising systems, robust reputation systems and craft collaborative systems with millions of active participants under continuous attack from spammers and other adversarial entities."


## Service configuration {#modules-services-tribler-service-configuration}

The basic server enablement for tribler is:
```nix
{
  services.tribler = {
    enable = true;
  };
}
```

The available options in the nix service are:

* `package`
  * Which tribler package to use, defaults to the release the service is from (ie nixos-XX.XX or nixos-unstable). It should be Tribler 8 or up.
* `port`
  * The port where the tribler web-gui and API will be accessible. Default is 10099. That is nix specific, the upstream package by itself generates a random port when the service starts.
* `dataDir`
  * This is the directory that tribler uses for it's internal data. The tribler program will create a hidden folder at this location. So if the path is `/var/log/tribler` then the program will create `/var/log/tribler/.Tribler` and store its internal configs in that `.Tribler` folder.
* `apiKey`
  * This is blank by default. The tribler program on its own generates a random string. It is used as authentication to the API, but if set you will need to add `?key=<yourkey>` to the url used to access the web-gui.
  * Example: If your key is `12345abcdef` then the default url to access the web-gui will be: `http://localhost:10099/ui/#downloads/all?key=12345abcdef`
* `user`
  * The user that the program will run as. Default is `tribler`. The user will be created if its `tribler`. If set to a user that is not `tribler` then you will have to create the user outside the service.
* `group`
  * The group that the program will run as. Default is `tribler`. The group will be created if its `tribler`. If set to a group that is not `tribler` then you will have to create the group outside the service.
* `openFirewall`
  * If true this will open the `port` in the firewall. Default is false.


## Other Tribler configuration methods.

The tribler program can be further configured using the web-gui's settings panel, or directly by editing the `configuration.json` file the program creates. The tribler program will create its configuration files at the `<dataDir>/.Tribler/` path. The default is `/var/lib/tribler/.Tribler/8.0/configuration.json`.

### Download location.

By default the tribler program will configure itself to download to the `~/Downloads` directory.

If the service runs with all defaults, then that will be the `/var/lib/tribler/Downloads` folder, as the created `tribler` user's home folder is set to `/var/lib/tribler`.

If you are running the service as `myuser` then tribler will set its download location to `/home/myuser/Downloads`.

This can be configured by changing the location in the web-gui's `Settings > General > Default download settings > Save files to` or by editing the `configuration.json` file. The path to look for in the json is `libtorrent.download_defaults.saveas`.

## Further Reading

[Tribler FAQ](https://www.tribler.org/faq.html)

[Tribler Github](https://github.com/Tribler/tribler)
