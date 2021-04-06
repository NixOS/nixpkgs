/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2021 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

#ifndef UNPACKFSC_UNPACKFSCJOB_H
#define UNPACKFSC_UNPACKFSCJOB_H

#include "Config.h"

#include <CppJob.h>
#include <DllMacro.h>
#include <utils/PluginFactory.h>

class PLUGINDLLEXPORT UnpackFSCJob : public Calamares::CppJob
{
    Q_OBJECT

public:
    explicit UnpackFSCJob( QObject* parent = nullptr );
    ~UnpackFSCJob() override;

    QString prettyName() const override;

    Calamares::JobResult exec() override;

    void setConfigurationMap( const QVariantMap& configurationMap ) override;

private:
    Config m_config;
};

CALAMARES_PLUGIN_FACTORY_DECLARATION( UnpackFSCFactory )

#endif
