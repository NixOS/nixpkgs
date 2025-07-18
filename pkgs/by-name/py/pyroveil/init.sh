#!/bin/sh

if [ -z "${pyroveil_package_path:-}" ]; then
  echo "No pyroveil_package_path variable set" >&2
  exit
fi

mkdir -p "$HOME/.local/share/"
cp -r --no-preserve=mode,ownership \
  "$pyroveil_package_path/share/vulkan/implicit_layer.d/VkLayer_pyroveil_64.json" \
  "$HOME/.local/share/vulkan/implicit_layer.d/"

rm -f "$HOME/.local/share/pyroveil"
ln -sf "$pyroveil_package_path/share/pyroveil" "$HOME/.local/share/"
