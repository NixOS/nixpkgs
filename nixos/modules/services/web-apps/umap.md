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

## Custom pictograms {#module-services-umap-pictograms}

Icon collections can be served from the Nix store via
`UMAP_PICTOGRAMS_COLLECTIONS`; each path must contain a
`pictograms/<category>/` directory layout.

```nix
{
  services.umap.settings.UMAP_PICTOGRAMS_COLLECTIONS = {
    "My icons".path = "${pkgs.my-umap-pictograms}";
  };
}
```
