from setuptools import setup, find_packages

setup(
    name='@pname@',
    version='@version@',
    install_requires=[
        "imapclient"
    ],
    entry_points={
        'console_scripts': ['imapwatcher=beforeMain:execute_main']
    },
)
