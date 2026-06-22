export group="${AZURE_RESOURCE_GROUP:-"azure"}"
export location="${AZURE_LOCATION:-"westus2"}"

img_file=$(echo azure/*.vhd)
img_name="$(basename "${img_file}")"
img_name="${img_name%".vhd"}"
export img_name="${img_name//[._]/-}"
