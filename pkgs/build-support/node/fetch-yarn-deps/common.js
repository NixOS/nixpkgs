const path = require('path')

// This has to match the logic in pkgs/development/tools/yarn2nix-moretea/yarn2nix/lib/urlToName.js
// so that fixup_yarn_lock produces the same paths
const urlToName = url => {
	const isCodeloadGitTarballUrl = url.startsWith('https://codeload.github.com/') && url.includes('/tar.gz/')

	if (url.startsWith('git+') || isCodeloadGitTarballUrl) {
		return path.basename(url)
	} else {
		return url
			.replace(/https:\/\/(.)*(.com)\//g, '') // prevents having long directory names
			.replace(/[@/%:-]/g, '_') // replace @ and : and - and % characters with underscore
	}
}

module.exports = { urlToName };
