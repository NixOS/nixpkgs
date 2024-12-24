# shellcheck shell=bash

# Populate XDG_ICON_DIRS
hicolorIconThemeHook() {

    # where to find icon themes
    if [ -d "$1/share/icons" ]; then
      addToSearchPath XDG_ICON_DIRS "$1/share"
    fi
}

# I think this is meant to be a runtime dep
addEnvHooks "${targetOffset:?}" hicolorIconThemeHook

# Make symbolic links of parent icon themes that are inherited in the
# icon themes installed by the package.
symlinkParentIconThemes() {
    if [ -e $out/share/icons ]; then
        echo Symlinking parent icon themes...
        local theme
        local theme_name
        local inheritance
        local parent
        local parent_theme
        local dir
        local parent_path
        for theme in $out/share/icons/*/index.theme; do
            theme_name="${theme%/*}"
            theme_name="${theme_name##*/}"
            echo "  theme: $theme_name"
            inheritance=$(sed -rne 's,^Inherits=(.*)$,\1,p' "$theme")
            IFS=',' read -ra parent_themes <<< "$inheritance"
            for parent_theme in "${parent_themes[@]}"; do
                parent_path=""
                if [ -e "$out/share/icons/$parent_theme" ]; then
                    parent_path="$(realpath "$out/share/icons/$parent_theme")"
                else
                    IFS=':' read -ra dirs <<< $XDG_ICON_DIRS
                    for parent_dir in  "${dirs[@]}"; do
                        if [ -e "$parent_dir/icons/$parent_theme/index.theme" ]; then
                            parent_path="$(realpath "$parent_dir/icons/$parent_theme")"
                            ln -s "$parent_path" "$out/share/icons/"
                            break
                        fi
                    done
                fi
                echo "    parent: $parent_theme	-> $parent_path"
            done
        done
    fi
}

preFixupHooks+=(symlinkParentIconThemes)
