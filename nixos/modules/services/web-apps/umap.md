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
