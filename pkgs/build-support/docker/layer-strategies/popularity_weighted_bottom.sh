availableLayers=$1

# The following code is fiddly w.r.t. ensuring every layer is created, and
# that no paths are missed. If you change the following lines, double-check
# that your code behaves properly when the number of layers equals:
#      maxLayers-1, maxLayers, and maxLayers+1, 0
jq -sR '
    rtrimstr("\n") | split("\n")
    | (.[:$availableLayers-1] | map([.])) + [ .[$availableLayers-1:] ]
    | map(select(length > 0))
' \
    --argjson availableLayers "$availableLayers"
