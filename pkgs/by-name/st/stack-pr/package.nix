{
	python3Packages,
	fetchFromGitHub,
	lib,
	git,
	gh,
	makeWrapper,
}:
python3Packages.buildPythonApplication (finalAttrs: {
		pname = "stack-pr";
		version = "0.1.7";
		pyproject = true;
		build-system = [python3Packages.pdm-backend];

		src =
			fetchFromGitHub {
				repo = "stack-pr";
				owner = "modular";
				rev = "${finalAttrs.version}";
				hash = "sha256-bOzSUE0bRMV6mskFjEJ0hDOnS7YpCrEpREf8ASXJkdU=";
			};

		nativeBuildInputs = [
			makeWrapper
		];

		postFixup = ''
			wrapProgram $out/bin/stack-pr \
			    --prefix PATH : ${lib.makeBinPath [git gh]}
		'';
	})
