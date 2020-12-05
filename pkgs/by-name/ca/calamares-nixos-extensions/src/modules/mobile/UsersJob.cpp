/* SPDX-FileCopyrightText: 2020 Oliver Smith <ollieparanoid@postmarketos.org>
 * SPDX-License-Identifier: GPL-3.0-or-later */
#include "UsersJob.h"

#include "GlobalStorage.h"
#include "JobQueue.h"
#include "Settings.h"
#include "utils/CalamaresUtilsSystem.h"
#include "utils/Logger.h"

#include <QDir>
#include <QFileInfo>


UsersJob::UsersJob( QString cmdPasswd, QString cmdSshd, QString cmdSshdUseradd,
                    bool isSshEnabled,
                    QString username, QString password,
                    QString sshdUsername, QString sshdPassword )
    : Calamares::Job()
    , m_cmdPasswd (cmdPasswd)
    , m_cmdSshd (cmdSshd)
    , m_cmdSshdUseradd (cmdSshdUseradd)
    , m_isSshEnabled (isSshEnabled)
    , m_username (username)
    , m_password (password)
    , m_sshdUsername (sshdUsername)
    , m_sshdPassword (sshdPassword)
{
}


QString
UsersJob::prettyName() const
{
    return "Configuring users";
}

Calamares::JobResult
UsersJob::exec()
{
    using namespace Calamares;
    using namespace CalamaresUtils;
    using namespace std;

    QList< QPair<QStringList, QString> > commands = {
        { {"sh", "-c", m_cmdPasswd + " " + m_username}, m_password + "\n" + m_password + "\n" },
        { {"sh", "-c", m_cmdSshd}, QString()},
    };

    if (m_isSshEnabled) {
        commands.append({{"sh", "-c", m_cmdSshdUseradd + " " + m_sshdUsername},
                         QString()});
        commands.append({{"sh", "-c", m_cmdPasswd + " " + m_sshdUsername},
                         m_sshdPassword + "\n" + m_sshdPassword + "\n"});
    }

    foreach( auto command, commands ) {
        auto location = System::RunLocation::RunInTarget;
        const QString pathRoot = "/";
        const QStringList args = command.first;
        const QString stdInput = command.second;

        ProcessResult res = System::runCommand( location, args, pathRoot,
                                                stdInput,
                                                chrono::seconds( 30 ));
        if ( res.getExitCode() ) {
            return JobResult::error( "Command failed:<br><br>"
                                     "'" + args.join(" ") + "'<br><br>"
                                     " with output:<br><br>"
                                     "'" + res.getOutput() + "'");
        }
    }

    return JobResult::ok();
}
