const anchor = document.location.hash.substring(1);
const current_location = "LOCATION_PLACEHOLDER";
const redirects = REDIRECTS_PLACEHOLDER;

function relativePathFrom(origin, to) {
    // Split paths into parts, removing empty segments
    const originParts = origin.split('/').filter(p => p);
    const toParts = to.split('/').filter(p => p);

    // Get directory parts (exclude filename from origin)
    const originDir = originParts.slice(0, -1);

    // Find common path length
    let commonLength = 0;
    const minLength = Math.min(originDir.length, toParts.length);

    for (let i = 0; i < minLength; i++) {
        if (originDir[i] === toParts[i]) {
            commonLength++;
        } else {
            break;
        }
    }

    // Calculate steps up and down
    const stepsUp = originDir.length - commonLength;
    const stepsDown = toParts.slice(commonLength);

    // Build relative path
    const result = Array(stepsUp).fill('..').concat(stepsDown);

    return result.length === 0 ? '.' : result.join('/');
}

if (redirects[anchor] && redirects[anchor] !== current_location) {
    redirect_path = relativePathFrom(current_location, redirects[anchor]);
    if (!redirect_path.includes('#')) {
        redirect_path = redirect_path + "#" + anchor;
    }

	document.location.href = redirect_path;
}
