# Mattermost {#sec-mattermost}

The NixOS Mattermost module lets you build [Mattermost](https://mattermost.com)
instances for collaboration over chat, optionally with custom builds of plugins
specific to your instance.

To enable Mattermost using Postgres, use a config like this:

```nix
{
  services.mattermost = {
    enable = true;

    # You can change this if you are reverse proxying.
    host = "0.0.0.0";
    port = 8065;

    # Allow modifications to the config from Mattermost.
    mutableConfig = true;

    # Override modifications to the config with your NixOS config.
    preferNixConfig = true;

    socket = {
      # Enable control with the `mmctl` socket.
      enable = true;

      # Exporting the control socket will add `mmctl` to your PATH, and export
      # MMCTL_LOCAL_SOCKET_PATH systemwide. Otherwise, you can get the socket
      # path out of `config.mattermost.socket.path` and set it manually.
      export = true;
    };

    # For example, to disable auto-installation of prepackaged plugins.
    settings.PluginSettings.AutomaticPrepackagedPlugins = false;
  };
}
```

As of NixOS 25.05, Mattermost uses peer authentication with Postgres or
MySQL by default. If you previously used password auth on localhost,
this will automatically be configured if your `stateVersion` is set to at least
`25.05`.

## Using the Mattermost derivation {#sec-mattermost-derivation}

The nixpkgs `mattermost` derivation runs the entire test suite during the
`checkPhase`. This test suite is run with a live MySQL and Postgres database
instance in the sandbox. If you are building Mattermost, this can take a while,
especially if it is building on a resource-constrained system.

The following passthrus are designed to assist with enabling or disabling
the `checkPhase`:

- `mattermost.withTests`
- `mattermost.withoutTests`

The default (`mattermost`) is an alias for `mattermost.withTests`.

## Using Mattermost plugins {#sec-mattermost-plugins}

You can configure Mattermost plugins by either using prebuilt binaries or by
building your own. We test building and using plugins in the NixOS test suite.

Mattermost plugins are tarballs containing a system-specific statically linked
Go binary and webapp resources.

Here is an example with a prebuilt plugin tarball:

```nix
{
  services.mattermost = {
    plugins = with pkgs; [
      # todo
      # 0.7.1
      # https://github.com/mattermost/mattermost-plugin-todo/releases/tag/v0.7.1
      (fetchurl {
        # Note: Don't unpack the tarball; the NixOS module will repack it for you.
        url = "https://github.com/mattermost-community/mattermost-plugin-todo/releases/download/v0.7.1/com.mattermost.plugin-todo-0.7.1.tar.gz";
        hash = "sha256-P+Z66vqE7FRmc2kTZw9FyU5YdLLbVlcJf11QCbfeJ84=";
      })
    ];
  };
}
```

Once the plugin is installed and the config rebuilt, you can enable this plugin
in the System Console.

## Building Mattermost plugins {#sec-mattermost-plugins-build}

The `mattermost` derivation includes the `buildPlugin` passthru for building
plugins that use the "standard" Mattermost plugin build template at
[mattermost-plugin-demo](https://github.com/mattermost/mattermost-plugin-demo).

Since this is a "de facto" standard for building Mattermost plugins that makes
assumptions about the build environment, the `buildPlugin` helper tries to fit
these assumptions the best it can.

Here is how to build the above Todo plugin. Note that we rely on
package-lock.json being assembled correctly, so must use a version where it is!
If there is no lockfile or the lockfile is incorrect, Nix cannot fetch NPM build
and runtime dependencies for a sandbox build.

```nix
{
  services.mattermost = {
    plugins = with pkgs; [
      (mattermost.buildPlugin {
        pname = "mattermost-plugin-todo";
        version = "0.8-pre";
        src = fetchFromGitHub {
          owner = "mattermost-community";
          repo = "mattermost-plugin-todo";
          # 0.7.1 didn't work, seems to use an older set of node dependencies.
          rev = "f25dc91ea401c9f0dcd4abcebaff10eb8b9836e5";
          hash = "sha256-OM+m4rTqVtolvL5tUE8RKfclqzoe0Y38jLU60Pz7+HI=";
        };
        vendorHash = "sha256-5KpechSp3z/Nq713PXYruyNxveo6CwrCSKf2JaErbgg=";
        npmDepsHash = "sha256-o2UOEkwb8Vx2lDWayNYgng0GXvmS6lp/ExfOq3peyMY=";
        extraGoModuleAttrs = {
          npmFlags = [ "--legacy-peer-deps" ];
        };
      })
    ];
  };
}
```

See `pkgs/by-name/ma/mattermost/build-plugin.nix` for all the options.
As in the previous example, once the plugin is installed and the config rebuilt,
you can enable this plugin in the System Console.
