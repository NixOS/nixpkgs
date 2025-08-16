/**
 * A simple bun.lock parser specifically designed to extract package information
 * while being tolerant of control characters in base64 strings and trailing commas.
 *
 * Bun.lock is a JSONC format (JSON with comments and trailing commas), but we
 * only need to extract specific information from it.
 */
const parseBunLock = (lockContents, stripJsonComments) => {
	try {
		// Strip comments from the JSON
		const cleanJson = stripJsonComments(lockContents);

		// Try standard JSON parsing first, but if it fails, use our manual regex approach
		try {
			// Try standard JSON parsing with trailing comma fix
			return JSON.parse(cleanJson.replace(/,(\s*[}\]])/g, '$1'));
		} catch (e) {
			// If JSON.parse fails, use a manual regex-based parser

			// Extract lockfileVersion
			const versionMatch = cleanJson.match(/"lockfileVersion"\s*:\s*(\d+)/);
			const lockfileVersion = versionMatch ? parseInt(versionMatch[1], 10) : 1;

			// Extract packages section using regex
			const packagesMatch = cleanJson.match(/"packages"\s*:\s*{([\s\S]+?)}(?=\s*}|\s*,\s*")/);
			if (!packagesMatch) {
				// If no packages section, return empty object
				return { lockfileVersion, packages: {} };
			}

			const packagesContent = packagesMatch[1];
			const packages = {};

			// Extract each package entry - the format is:
			// "package-name": ["name@version", "url", {metadata}, "integrity"]
			const packageRegex = /"([^"]+)"\s*:\s*\[([\s\S]*?)(?=\],|\]$)/g;
			let match;

			while ((match = packageRegex.exec(packagesContent)) !== null) {
				const packageName = match[1];
				const packageDetailsStr = match[2];

				// Parse the array elements
				const parts = [];
				let currentPart = '';
				let depth = 0;
				let inString = false;

				// Simple state machine to parse the package details
				for (let i = 0; i < packageDetailsStr.length; i++) {
					const char = packageDetailsStr[i];

					// Handle string boundaries and nesting
					if (char === '"' && (i === 0 || packageDetailsStr[i-1] !== '\\')) {
						inString = !inString;
						currentPart += char;
					} else if (!inString && (char === '{' || char === '[')) {
						depth++;
						currentPart += char;
					} else if (!inString && (char === '}' || char === ']')) {
						depth--;
						currentPart += char;
					} else if (!inString && char === ',' && depth === 0) {
						// Element separator at the top level
						parts.push(currentPart.trim());
						currentPart = '';
					} else {
						currentPart += char;
					}
				}

				// Add the last part if there is one
				if (currentPart.trim()) {
					parts.push(currentPart.trim());
				}

				// Store the parts array for this package
				packages[packageName] = parts;
			}

			return { lockfileVersion, packages };
		}
	} catch (err) {
		throw new Error(`Failed to parse bun.lock file: ${err.message}`);
	}
};

module.exports = { parseBunLock };
