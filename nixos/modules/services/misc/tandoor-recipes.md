# Tandoor Recipes {#module-services-tandoor-recipes}

## Dealing with `MEDIA_ROOT` for installations prior 26.05 {#module-services-tandoor-recipes-migrating-media}

See https://github.com/NixOS/nixpkgs/issues/338339 for some background.

### Option 1: Migrate media to new `MEDIA_ROOT` {#module-services-tandoor-recipes-migrating-media-option-1}

1. Stop the currently running service: `systemctl stop tandoor-recipes.service`
2. Create a media folder. NixOS `26.05` creates the media path at `/var/lib/tandoor-recipes/media` by default, but you may choose any other path as well. `mkdir -p /var/lib/tandoor-recipes/media`
3. Move existing media to the new path: `mv /var/lib/tandoor-recipes/{files,recipes} /var/lib/tandoor-recipes/media`
4. Set `services.tandoor-recipes.extraConfig.MEDIA_ROOT = "/var/lib/tandoor-recipes/media";` in your NixOS configuration (not needed if `system.stateVersion >= 26.05`).
5. Rebuild and switch!

These changes can be reverted by moving the files back into the state directory.

### Option 2: Keep existing directory (may be insecure) {#module-services-tandoor-recipes-migrating-media-option-2}

To keep the existing directory, set `services.tandoor-recipes.extraConfig.MEDIA_ROOT = "/var/lib/tandoor-recipes";`.
