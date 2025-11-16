# Umap {#module-services-umap}

[Umap](https://umap-project.org/) is a tool to create custom maps with OpenStreetMap layers.

## Basic Usage {#module-services-umap-basic-usage}

A minimal configuration to run Umap:

```nix
{
  services.umap = {
    enable = true;
    settings.SITE_URL = "https://umap.example.com";
  };
}
```

## Share a TLS certificate {#module-services-umap-acme}

```nix
{
  security.acme.certs."example.com".extraDomainNames = [ "umap.example.com" ];
  services.nginx.virtualHosts."umap.example.com".useACMEHost = "example.com";
}
```

The module requests a dedicated ACME certificate for the host in
{option}`services.umap.settings.SITE_URL`. Selecting an existing certificate on
the virtual host suppresses that request, which keeps several subdomains on a
single certificate and away from the Let's Encrypt
[rate limit](https://letsencrypt.org/docs/rate-limits).

## Create an admin account {#module-services-umap-admin-account}

Umap manages users, maps and tile layers through the Django admin site. Create an
account that can reach it:

```bash
umap-manage createsuperuser
```

This prompts for a username, email and password. Log in at `$SITE_URL/admin/`.

The preconfigured CARTO tile layer does not work out of the box, since CARTO now
requires an API key. Replace it under *Tile layers*, for example with the
standard OpenStreetMap tiles at
`https://tile.openstreetmap.org/{z}/{x}/{y}.png`. See the
[upstream documentation](https://docs.umap-project.org/en/stable/config/admin/).

## Marker icons {#module-services-umap-pictograms}

Umap ships no marker icons of its own, so this module serves the
[Osmic](https://github.com/gmgeo/osmic) collection from the Nix store. The
[upstream documentation](https://docs.umap-project.org/en/stable/config/icons/)
lists other icon libraries to choose from.

Icons must sit directly in `pictograms/<category>/`. Umap scans one level of
categories and silently ignores anything deeper, so a set that ships a flat
icon directory, such as [Pinhead](https://github.com/waysidemapping/pinhead),
lands in a single category unless you group it yourself:

```nix
let
  pinhead = pkgs.runCommand "pinhead-pictograms" { } ''
    install -Dm444 -t $out/pictograms/pinhead ${
      pkgs.fetchFromGitHub {
        owner = "waysidemapping";
        repo = "pinhead";
        tag = "v15.25.0";
        hash = "sha256-J2dTXUaZ40e11T9Bs4wAmPo4Dlt1YMWzEXcRh+8rqe8=";
      }
    }/icons/*.svg
  '';
in
{
  services.umap.settings.UMAP_PICTOGRAMS_COLLECTIONS.Pinhead = {
    path = "${pinhead}";
    attribution = "Wayside Mapping";
  };
}
```

Osmic is still served alongside it; wrap the value in `lib.mkForce` to serve
Pinhead alone. Maps keep the URL of every icon they use, so dropping Osmic
breaks the markers of an existing map that point at one of its icons.
